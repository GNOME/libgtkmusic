using Gtk;
using Gee;

//TODO Make a QCAD picture with all relevant dimensions and offsets
//TODO Labels

/* 
  Performance Notes
 - what's the cost of detecting whether a MIDI code is an accident ?
    => low, the implementation of MusicalNotes.midi_is_accident is "cheap"
 - what's the cost of getting the x coordinates for a MIDI code ?
    => low, little math in a loop with a maximum of 12-iterations
 - iterate marked_notes hash map VS check for keys while iterating in the other
   draw routines
    => iterate marked_notes, if done only once, seems less expensive
 - what's the cost of replacing rectangles by polygons for natural keys ?
    => the polygon form depends whether the key is preceeded or followed by
       an accident.
 - would it be good to join marked notes drawing routines in the main draw
   routine ?
    => probably not, since checking the map for key existence is slower than
       iterating it only once or twice
 - with which frequency the piano will be redrawed ?
    => frequently, since every mark / unmark / click event will trigger a draw
    
 Current procedure:
    - draw natural keys
    - draw marked natural keys, iterating marked notes 
    - draw accidentals
    - draw marked accidentals, reiterating marked notes
*/

namespace GtkMusic {

/** 
 * Piano widget custom errors 
 */
public errordomain PianoError {
    INVALID_COORDINATES
}

/**
 * Piano widget
 **/
public class Piano : DrawingArea {

    //=========================================================================
    //Signals
    //=========================================================================
    
    /**
     * Signal emitted when a note has been pressed with the mouse
     * @param event The Gdk low level event object
     * @param midi_note The MIDI value (number) of the pressed note
     */
    public signal void note_pressed (Gdk.EventButton event,
                                     int midi_note); //ushort not supported?

    /**
     * Signal emitted when a note has been released (mouse button released)
     * @param event The Gdk low level event object
     * @param midi_note The MIDI value (number) of the released note
     */
    public signal void note_released (Gdk.EventButton event,
                                      int midi_note); //ushort not supported?
  
    //=========================================================================
    //Properties
    //=========================================================================
    
    /**
     * Possible keys labels positions
     */
    public enum LabelPosition {
        UP,
        DOWN
    }

    /**
     * Automatically redraw the piano whenever there's a change
     */
    public bool auto_update = true;

    /**
     * Number of keys
     */
    public ushort key_count = 24;

    /**
     * MIDI Code of the first key's note (Defaults to C2)
     */
    public ushort first_note = 36;  //C2

    /**
     * RGBA color used to draw natural keys
     */
    public float[] nat_key_color = {1.0f, 1.0f, 1.0f, 1.0f};

    /**
     * RGBA color used to draw accident keys
     */
    public float[] accident_key_color = {0.0f, 0.0f, 0.0f, 1.0f};

    /**
     * Whether note names should be drawn
     */
    public bool show_labels = false;
    
    /**
     * Show octaves should be added in labels (e.g. E4)
     */
    public bool detailed_labels = false;

    /**
     * Labels position
     */
    public LabelPosition labels_position = LabelPosition.UP;

    /**
     * A style for a given marked note (currently only a color)
     */
    public class MarkedNoteStyle {
        public float[] color = {0.5f, 0.5f, 0.5f, 1.0f};
        public MarkedNoteStyle(float[] color) {
            this.color = color;
        }
    }

    /**
     * Dictionary of marked notes
     */
    public HashMap<ushort, MarkedNoteStyle> marked_notes;
    
    //=========================================================================
    //Private properties
    //=========================================================================
    
    private ushort h_padding = 2;
    private ushort v_padding = 2;
    private float accident_key_height = 0.7f;
    private float accident_key_width = 0.4f;
    private ushort nat_keys;
    private double piano_width;
    private double piano_height;
    private double piano_x;
    private double piano_y;
    private double width;
    private double height;
    private double key_width;
    
    
    //=========================================================================
    //Methods
    //=========================================================================
   
    /**
     * Create a new Piano widget, which minimum size is defined to 120x40
     **/
    public Piano() {
        /* add_events (Gdk.EventMask.BUTTON_PRESS_MASK
                  | Gdk.EventMask.BUTTON_RELEASE_MASK); */
        marked_notes = new HashMap<ushort, MarkedNoteStyle> ();
        set_size_request (120, 40);  //minimum widget size
    }
    
    //====Marking-related======================================================
    
    /**
     * Highlight a key corresponding to a MIDI code
     * @param midi_note A valid MIDI code (in range: 21 .. 108)
     * @param color The color (in RGBA []) to fill the marked key (default: blue)
     **/
    public void mark_midi(ushort midi_note, 
                          float[] color = {0.0f, 0.0f, 0.5f, 1.0f}) {
        marked_notes[midi_note] = new MarkedNoteStyle(color);
        if(auto_update)
            redraw();     
    }
    
   /**
    * Remove the mark of a position in the instrument
    * @param midi_note A valid MIDI code (in range: 21 .. 108)
    **/
    public void unmark_midi(ushort midi_note) {
        if(marked_notes.has_key(midi_note))
            marked_notes.unset(midi_note);
        if(auto_update)
            redraw();    
    }
    
   /**
    * Highlight all positions corresponding to a note
    * @param note A musical note in scientific notation (examples: F#4 , C)
    **/
    public void mark_note(string note,
                          float[] color = {0.0f, 0.0f, 0.5f, 1.0f}) {
        bool old_auto_update = auto_update;

        //Preparing list of keys to mark
        var positions = find_positions(note);
        if(positions == null)
            return;
        
        //Adding keys to marked notes
        foreach(ushort u in positions)
            marked_notes[u] = new MarkedNoteStyle(color);
        
        auto_update = old_auto_update;
        if(auto_update)
            redraw();
    }

   /**
    * Remove the marks in all positions corresponding to a note
    * @param note A musical note in scientific notation (examples: F#4 , C)
    **/
    public void unmark_note(string note) {
        bool old_auto_update = auto_update;
        
        //Preparing list of keys to unmark
        var positions = find_positions(note);
        if(positions == null)
            return;
        
        //Adding keys to marked notes
        foreach(ushort u in positions)
            marked_notes.unset(u);

        auto_update = old_auto_update;
        if(auto_update)
            redraw();  
    }
    
   /**
    * Remove all marked notes in the Piano view
    **/ 
    public void unmark_all() {
        marked_notes.clear();
        if(auto_update)
            redraw();
    }
    
    //====Coordinates or calculus related======================================

    /**
     * Get the MIDI code corresponding to a point (x,y) in the widget
     * @param x Valid x coordinate
     * @param y Valid y coordinate
     **/    
    public ushort point_to_midi(double x, double y) throws PianoError {
        //TODO Replace this by simple mathematical evaluation ?
        double delta_x;
        double ak_sep = (accident_key_width * key_width) / 2;
        double ak_height = accident_key_height * piano_height;
        ushort r1_key, r2_key, r3_key; //regions (top-left, middle, top-right)
        bool curr_accident; //current note is an accident
        bool next_accident; //note after a horizontal step is an accident
        for(var i = first_note ; i < first_note + key_count ; i++) {
            delta_x = x - midi_to_x(i);
            
            if(delta_x < key_width) {                     // in close region
            
                curr_accident = MusicalNotes.midi_is_accident(i);
                if(curr_accident)
                    next_accident = MusicalNotes.midi_is_accident(i + 2);
                else
                    next_accident = MusicalNotes.midi_is_accident(i + 1);
                
                //Region 1
                r1_key = i;                      //region 1 is always curr note
                //Region 2
                if(curr_accident)
                    r2_key = i + 1;
                else
                    r2_key = i;
                //Region 3
                if (curr_accident && next_accident)
                    r3_key = i + 2;
                else if (curr_accident && !next_accident)
                    r3_key = i + 1;
                else if (!curr_accident && next_accident)
                    r3_key = i + 1;
                else
                    r3_key = i;
                
                //Identifying regions
                if (delta_x < ak_sep && y < ak_height)
                    return r1_key;
                else if (delta_x > (key_width - ak_sep) && y < ak_height)
                    return r3_key;
                else
                    return r2_key;
            }
        }
        throw new PianoError.INVALID_COORDINATES("Invalid coordinates!");
    }
    
    /**
     * Get the x coordinate of the key associated to a given MIDI code
     * @param midi_code A valid MIDI code, present in the piano range
     **/
    public double midi_to_x(ushort midi_code) {
        ushort norm_key = midi_code - first_note;
        if(norm_key < 0 || norm_key > (first_note + key_count))
            return -1; //TODO Throw exception ??
        double x = piano_x;
        x += (int) (norm_key / 12) * 7 * key_width; //skipping octaves
        bool last_was_nkey = false;
        for(var i = 0 ; i < (norm_key % 12) + 1 ; i++) {
            if(last_was_nkey)  //only increment x when the last key was natural
                x += key_width;
            last_was_nkey = !MusicalNotes.midi_is_accident(i);
        }
        return x;
    }
    
   /**
    * Find all MIDI codes for a given note
    * @param note The note with or without the octave component (e.g: A#, D4)
    **/
    public HashSet<ushort>? find_positions(string note) {
        if(!MusicalNotes.validate(note) && !MusicalNotes.is_incomplete(note))
            return null;
        
        HashSet<ushort> midi_codes = new HashSet<ushort> ();
        
        if(MusicalNotes.is_incomplete(note)) {
            foreach(string s in MusicalNotes.make(note))
                midi_codes.add((ushort) MusicalNotes.get_note_as_midi_code(s));
        }
        else
            midi_codes.add((ushort) MusicalNotes.get_note_as_midi_code(note));
        
        return midi_codes;
    }
    
    /**
     * Return the number of natural keys for the current instance parameters
     * @return The number of natural keys
     **/
    private ushort get_natural_keys_count() {
        ushort complete_octaves = (ushort) (key_count / 12);
        ushort incomplete_octave = (ushort) (key_count % 12);
        ushort nat_keys = complete_octaves * 7; //7 natural-notes per octave
        ushort tmp_note;
        for(var i = 0; i < incomplete_octave; i++) { //iterating rem. keys
            tmp_note = (first_note + i) % 12; //normalized offset
            if(!MusicalNotes.midi_is_accident(tmp_note))
                nat_keys += 1;   
        }
        return nat_keys;  
    }
    

    
    //====Events===============================================================
    
   /**
    * Customized button_press_event
    *
    * Add the current position and note to the standard button-press event and
    * emits a note_pressed signal.
    */
    public override bool button_press_event (Gdk.EventButton event) {
        note_pressed(event, point_to_midi(event.x, event.y));
        return true;
    }
    
   /**
    * Customized button_released_event
    *
    * Add the current position and note to the standard button-release event 
    * and emits a note_released signal.
    */
    public override bool button_release_event (Gdk.EventButton event) {
        note_released(event, point_to_midi(event.x, event.y));
        return true;
    }
    
    //====Drawing methods======================================================
    
   /**
    * Draw the piano widget
    *
    * @param cr The drawing context for the widget
    * @return Whether the event should be propagated (TODO Confirm this theory)
    */
    public override bool draw (Cairo.Context cr) {
        calculate_dimensions(cr);
        draw_natural_keys(cr);
        draw_accident_keys(cr);
        return false;
    }
    
    /**
    * Force a complete redraw of the widget
    *
    * This function will invalidate all the region corresponding to the
    * widget's GDK window and ask for updates, forcing a complete redraw.
    *
    */
    public void redraw () {
        var window = get_window ();
        if (null == window) {
            return;
        }
        Cairo.Region region = window.get_clip_region ();
        window.invalidate_region (region, true);
    }
    
   /**
    * Calculate some drawing dimensions
    * @param cr The drawing context for the widget
    */
    private void calculate_dimensions(Cairo.Context cr) {
        width = get_allocated_width (); //total width for the widget
        height = get_allocated_height (); //total height for the widget
        if(show_labels) {
            piano_height = (0.8 * height) - 2 * v_padding;
             cr.select_font_face("monospace", Cairo.FontSlant.NORMAL, 
                                Cairo.FontWeight.NORMAL);
            //TODO Fix this font size (Pango?)
            cr.set_font_size(0.05 * width); 
        }
        else
            piano_height = height - 2 * v_padding; 
        piano_width = width - 2 * h_padding;
        piano_x = h_padding;
        piano_y = (height - piano_height) - v_padding;
        nat_keys = get_natural_keys_count();
        key_width = piano_width / nat_keys;
    }
    
   /**
    * Draw natural notes (C, D, E, F, G, A, B)
    * @param cr The drawing context for the widget
    */
    private void draw_natural_keys(Cairo.Context cr) {
        double x = piano_x;
        double y = piano_y;
        
        cr.save();
        
        //Drawing all natural keys
        for(var i = 0 ; i < nat_keys ; i++)
            cr.rectangle(x + i * key_width, piano_y, key_width, piano_height);
        cr.stroke_preserve();
        cr.set_source_rgba(nat_key_color[0], nat_key_color[1], 
                           nat_key_color[2], nat_key_color[3]);
        cr.fill_preserve();
        cr.set_source_rgba(0.0f, 0.0f, 0.0f, 1.0f);
        cr.stroke();
        
        //Redrawing marked natural keys
        if(marked_notes != null) {
            foreach(var entry in marked_notes.entries) {
                if(!MusicalNotes.midi_is_accident(entry.key)) {
                    x = midi_to_x(entry.key);
                    cr.rectangle(x, y, key_width, piano_height);
                    cr.set_source_rgba(entry.value.color[0], entry.value.color[1],
                                    entry.value.color[2], entry.value.color[3]);
                    cr.fill_preserve();
                    cr.set_source_rgba(0.0f, 0.0f, 0.0f, 1.0f);
                    cr.stroke();
                }
            }
        }
        
        cr.restore();
    }
    
   /**
    * Draw natural notes (C#, D#, F#, G#, A#)
    * @param cr The drawing context for the widget
    */
    private void draw_accident_keys(Cairo.Context cr) {
        double x = piano_x;
        double y = piano_y;
        double w = accident_key_width * key_width;
        double h = accident_key_height * piano_height;
        
        cr.save();
        
        //Drawing all accidentals
        cr.set_source_rgba(accident_key_color[0], accident_key_color[1],
                           accident_key_color[2], accident_key_color[3]);
        for(var i = first_note; i < first_note + key_count ; i++) {
            if(MusicalNotes.midi_is_accident(i))
                cr.rectangle(x - w/2, y, w, h);
            else    
                x += key_width;
        }
        cr.fill_preserve();
        cr.set_source_rgba(0.0f, 0.0f, 0.0f, 1.0f);
        cr.stroke();
        
        
        //Redrawing marked accidentals
        if(marked_notes != null) {
            foreach(var entry in marked_notes.entries) {
                if(MusicalNotes.midi_is_accident(entry.key)) {
                    x = midi_to_x(entry.key);
                    cr.rectangle(x - w/2, y, w, h);
                    cr.set_source_rgba(entry.value.color[0], entry.value.color[1],
                                    entry.value.color[2], entry.value.color[3]);
                    cr.fill_preserve();
                    cr.set_source_rgba(0.0f, 0.0f, 0.0f, 1.0f);
                    cr.stroke();
                }
            }
        }
        
        cr.restore();
    }
}

}
