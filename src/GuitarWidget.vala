using Gtk;
using Gee;
using Gdk;

//TODO Make a QCAD picture with all relevant dimensions and offsets
//TODO Labels font correction

namespace GtkMusic {

/**
 * A guitar string with a particular tuning
 **/
public class GuitarString {
    /**
     * The note associated with this guitar string 
     */
    public string note { get; private set; }
    
    /**
     * Whether this note should be vibrating (sinusoidal movement animation) 
     */
    public bool vibrate { get; set; default = false; }
    
    /**
     * A random generator seed (vibration animation phase difference) 
     */
    public double vibrate_seed { get; set; }  
    
    /**
     * Guitar string color as a RGBA array of floats 
     */
    public RGBA color { get; set; }
    
    /**
     * Label color as a RGBA array of floats 
     */
    public RGBA label_color { get; set; }
    
    public GuitarString(string note) {
        this.note = note;
        color = {0.1f, 0.1f, 0.1f, 1.0f};
        label_color = {0.0f, 0.0f, 0.0f, 1.0f};
        vibrate_seed = Random.next_double();
    }
}

/**
 * A fret mark used to highlight a fret
 **/
public class GuitarFretMark {
    /**
     * The fret mark position 
     */
    public ushort position { get; private set; }
    
    /**
     * Available symbols to highlight a given position 
     */
    public enum Style {
        NONE,
        SOLID_CIRCLE,
        RECTANGLE,
        FANCY
    }
    
    /**
     * The current symbol to be used (defaults to NONE) 
     */
    public Style style { get; set; default = Style.NONE; }
    
    /** 
     * The fret mark color as an RGBA array of floats 
     */
    public RGBA color { get; set; }
    
    public GuitarFretMark(ushort position) {
        this.position = position;
        color = {0.8f, 0.8f, 0.8f, 1.0f};
    }
}

/**
 * A guitar position, composed by the string index and the fret index
 **/
public class GuitarPosition {

    /** 
     * The guitar string index [0,5] associated to this guitar position 
     */
    public ushort string_index { get; private set; }
    
    /** 
     * The fret index associated to this guitar position 
     */
    public ushort fret_index { get; private set; }
    
    public GuitarPosition(ushort string_index, ushort fret_index) {
        this.string_index = string_index;
        this.fret_index = fret_index;
    }
      
    public static uint hash_func(GuitarPosition key) {
        return (13 + key.string_index) * 23 + key.fret_index;
    }
    
    public static bool equal_func(GuitarPosition a, GuitarPosition b) {
        if(a.string_index == b.string_index && a.fret_index == b.fret_index)
            return true;
        return false; 
    } 
}

/**
 * The Guitar widget
 */
public class Guitar : DrawingArea {

    //=========================================================================
    //Signals
    //=========================================================================
    
    /**
     * Signal emitted when a note has been pressed with the mouse
     * @param event The Gdk low level event object
     * @param pos The GuitarPosition (string and fret) of the pressed note
     */
    public signal void note_pressed (Gdk.EventButton event,
                                     GuitarPosition pos);
                              
    /**
     * Signal emitted when a note has been released (mouse button released)
     * @param event The Gdk low level event object
     * @param pos The GuitarPosition (string and fret) of the released note
     */
    public signal void note_released (Gdk.EventButton event,
                                      GuitarPosition pos);
    
    //=========================================================================
    //Properties
    //=========================================================================
    
    //Behavior properties
    
    /**
     * Render string labels (e.g.: EADGBE) 
     */
    public bool show_labels { get; set; default = true; }
    
    /**
     * Show octaves in labels (e.g.: E4) 
     */
    public bool detailed_labels { get; set; default = false; }
    
    /** 
     * Draw additional line in 1st fret 
     */
    public bool highlight_first_fret { get; set; default = true; }
    
    /** 
     * Auto-redraw when a note is added (disable for manual management) 
     */
    public bool auto_update { get; set; default = true; }
    
    /** 
     * Whether the guitar should be animated (string vibrations)
     */
    private bool should_animate { get; set; default = false; }
    
    //Grid properties

    /** 
     * Number of frets 
     */
    public ushort fret_number { get; set; default = 17; }

    //public RGBA grid_bg_color = {0.57f, 0.39f, 0.30f, 1.0f};

    /**
     * Grid background color as a RGBA array of floats
     */
    public RGBA grid_bg_color { get; set; }

    /** 
     * Fret color as a RGBA array of floats 
     */
    public RGBA fret_color { get; set; }

    /** 
     * Collection of strings 
     */
    public ArrayList<GuitarString> guitar_strings { get; set; }

    /**
     * Collection of fret marks 
     */
    public HashSet<GuitarFretMark> fret_marks { get; set; }
    
    //Advanced style properties
    //TODO :: Guitar styles (classical, electrical, guitar hero, music school)
    
    //=========================================================================
    //Marked Notes
    //=========================================================================
    
    /** 
     * Style for marked notes 
     */
    public class MarkedNoteStyle {
        public RGBA color;

        public MarkedNoteStyle() {
            color = {0.0f, 0.0f, 0.0f, 1.0f};
        }

        public MarkedNoteStyle.with_color(RGBA color) {
            this.color = color;
        }
    }

    /** 
     * Marked notes dictionary (position and mark style) 
     */
    public HashMap<GuitarPosition, MarkedNoteStyle> marked_notes;
    
    //=========================================================================
    //Private properties
    //=========================================================================
    
    //Internal variables (really private)
    private double width;
    private double height;
    private double grid_width;
    private double grid_height;
    private double grid_x;
    private double grid_y;
    private double string_spacing;
    private double fret_spacing;
    private double fret_mark_radius;
    private double marked_note_radius;
    private float animate_instant = 0;
    //Defaults
    private string[] default_strings = {"E2", "A2", "D3", "G3", "B3", "E4"};
    private ushort[] default_fret_marks = {1, 3, 5, 7, 9, 12, 15, 17};
    private const int MINIMUM_WIDTH = 170;
    private const int MINIMUM_HEIGHT = 60;
    
    //=========================================================================
    //Methods
    //=========================================================================
    
   /**
    * Create a new Guitar widget, which minimum size is defined to 170x60
    **/
    construct {
        guitar_strings = new ArrayList<GuitarString> ();
        fret_marks = new HashSet<GuitarFretMark> ();
        marked_notes = new HashMap<GuitarPosition, MarkedNoteStyle> 
                          ( (Gee.HashDataFunc?) GuitarPosition.hash_func,
                            (Gee.EqualDataFunc?) GuitarPosition.equal_func );
        foreach(string s in default_strings)
            guitar_strings.add(new GuitarString(s));
        foreach(ushort i in default_fret_marks)
            fret_marks.add(new GuitarFretMark(i));
        grid_bg_color = {0.486f, 0.309f, 0.251f, 1.0f};
        fret_color = {0.6f, 0.6f, 0.6f, 1.0f};
        set_size_request (MINIMUM_WIDTH, MINIMUM_HEIGHT);  //minimum widget size
    }

    public override void size_allocate (Gtk.Allocation allocation) {
        if(allocation.width < MINIMUM_WIDTH)
            allocation.width = MINIMUM_WIDTH;
        if(allocation.height < MINIMUM_HEIGHT)
            allocation.height = MINIMUM_HEIGHT;
        base.size_allocate (allocation);
    }
    
    //=========================================================================
    //Animation related
    //=========================================================================
    
    /**
     * Start the animation on strings set to vibrate
     */ 
    public void start_animation() {
        should_animate = true;
        Timeout.add (10, update_animation);
    }
    
    /**
     * Stop the string vibration animation
     */
    public void stop_animation() {
        should_animate = false;
        animate_instant = 0;
    }
    
    /**
     * Draw a new frame of the vibration animation
     */
    private bool update_animation() {
        animate_instant += 0.3f;
        redraw();
        return should_animate;
    }
    
    //====Marking-related======================================================
    
   /**
    * Highlight a position (string and fret) in the instrument
    * @param string_index The string number (top string equals to 0)
    * @param fret_index The fret number
    **/
    public void mark_position(ushort string_index, ushort fret_index,
                              RGBA color = {0.0f, 0.0f, 0.0f, 1.0f}) {
        var key = new GuitarPosition(string_index, fret_index);
        marked_notes[key] = new MarkedNoteStyle.with_color(color);
        if(auto_update)
            redraw();
    }

   /**
    * Remove the mark of a position (string and fret) in the instrument
    * @param string_index The string number (topmost string equals to 0)
    * @param fret_index The fret number
    **/    
    public void unmark_position(ushort string_index, ushort fret_index) {
        var key = new GuitarPosition(string_index, fret_index);
        if(marked_notes.has_key(key))
            marked_notes.unset(key);
        if(auto_update)
            redraw();
    }
    
   /**
    * Remove all marked notes in the Guitar view
    **/ 
    public void unmark_all() {
        marked_notes.clear();
        if(auto_update)
            redraw();
    }
    
   /**
    * Highlight all positions corresponding to a note
    * @param note A musical note in scientific notation (examples: F#4 , C)
    **/
    public void mark_note(string note, 
                          RGBA color = {0.0f, 0.0f, 0.0f, 1.0f}) {
        bool oldAutoUpdate = auto_update;
        var positions = find_positions(note);
        if(positions == null)
            return;
        foreach(GuitarPosition k in positions) {
            mark_position(k.string_index, k.fret_index, color);
        }
        auto_update = oldAutoUpdate;
        if(auto_update)
            redraw();
    }
    
   /**
    * Remove the marks in all positions corresponding to a note
    * @param note A musical note in scientific notation (examples: F#4 , C)
    **/    
    public void unmark_note(string note) {
        bool oldAutoUpdate = auto_update;
        var positions = find_positions(note);
        if(positions == null)
            return;
        foreach(GuitarPosition k in positions) {
            unmark_position(k.string_index, k.fret_index);
        }
        auto_update = oldAutoUpdate;
        if(auto_update)
            redraw();
    }
    
    //=====Coordinates and units related (Note <--> GuitarPosition <--> x,y)===
    
    /**
     * Compute the fret index to accomplish a given note in a given string
     * @param string_index The guitar string index
     * @param note The musical note in scientific notation
     * @return The position where the note can be found or -1
     **/
    public short note_position_in_string(ushort string_index, string note) {
        string firstNote = guitar_strings[string_index].note;
        var midiA = MusicalNotes.get_note_as_midi_code(firstNote);
        var midiB = MusicalNotes.get_note_as_midi_code(note);
        short result = (short) (midiB - midiA);
        if(result > fret_number)
            return -1;
        return result;
    }
    
   /**
    * Find all positions of a given note
    * @param note The note with or without the octave component (e.g: A#, D4)
    **/
    public HashSet<GuitarPosition>? find_positions(string note) {
        if(!MusicalNotes.validate(note) && !MusicalNotes.is_incomplete(note))
            return null;

        short fret_index;
        HashSet<string> notesWithOctaves;
        var validPositions = new HashSet<GuitarPosition> (
            (Gee.HashDataFunc?) GuitarPosition.hash_func,
            (Gee.EqualDataFunc?) GuitarPosition.equal_func
        );
        
        //Getting list of "complete" notes (with octave component)
        if(!MusicalNotes.is_incomplete(note)) { //already complete
            notesWithOctaves = new HashSet<string> ();
            notesWithOctaves.add(note);
        }
        else //need to get all octaves
            notesWithOctaves = MusicalNotes.make(note);
        
        //Finding positions
        foreach(string n in notesWithOctaves) {
            for(var s = 0 ; s < guitar_strings.size ; s++) {
                fret_index = note_position_in_string(s, n);
                if(fret_index >= 0)
                    validPositions.add(new GuitarPosition(s, fret_index));
            }
        }
        return validPositions;
    }
    
   /**
    * Get a MIDI code from a guitar position
    **/
    public ushort position_to_midi(GuitarPosition position) {
        string first_note = guitar_strings[position.string_index].note;
        ushort midi = MusicalNotes.get_note_as_midi_code(first_note);
        midi += position.fret_index;
        return midi;
    }
    
   /**
    * Convenient function for getting a note name from a guitar position
    **/
    public string position_to_note(GuitarPosition position) {
        ushort midi = this.position_to_midi(position);
        return MusicalNotes.get_note_from_midi_code(midi);
    }

    /**
     * Find the guitar position associated to a point
     * @param x The x coordinate of the point
     * @param y The y coordinate of the point
     **/    
    private GuitarPosition? point_to_position(double x, double y) {
        float x_tolerance = 0.4f; //Max normalized distance from fret center
        float y_tolerance = 0.2f; //Max normalized distance from string y coord

        //Translate coordinates
        x -= grid_x;
        y -= grid_y;
        
        //Normalized offsets
        double fretOffset = (double) (x % fret_spacing) / fret_spacing;
        double stringOffset = (double) (y % string_spacing) / string_spacing;
        
        //Checking offsets (from fret center for x, from string base for y)
        if(Math.fabs(fretOffset - 0.5) > x_tolerance || //fret center
           (stringOffset < (1 - y_tolerance) && stringOffset > y_tolerance) )
           return null;
        
        ushort fret_index = (ushort) (x/fret_spacing);
        ushort string_index = (ushort) (y/string_spacing);
        if(stringOffset > (1 - y_tolerance)) //in order to get nearest string
            string_index += 1;
        
        return new GuitarPosition(string_index, fret_index);
    }
    
    //=====Events==============================================================
    
   /**
    * Customized button_press_event
    *
    * Add the current position and note to the standard button-press event and
    * emits a note_pressed signal.
    **/
    public override bool button_press_event (Gdk.EventButton event) {
        GuitarPosition? pos = point_to_position(event.x, event.y);
        if(pos != null)
            note_pressed(event, pos);
        return true;
    }

   /**
    * Customized button_released_event
    *
    * Add the current position and note to the standard button-release event 
    * and emits a note_released signal.
    **/
    public override bool button_release_event (Gdk.EventButton event) {
        GuitarPosition? pos = point_to_position(event.x, event.y);
        if(pos != null)
            note_released(event, pos);
        return true;   
    }

    
    //====Drawing methods======================================================
    
   /**
    * Draw the guitar widget
    *
    * @param cr The drawing context for the widget
    * @return Whether the event should be propagated (TODO Confirm this theory)
    **/
    public override bool draw (Cairo.Context cr) {
        //stdout.printf("Draw called [START]."); stdout.flush();
        calculate_dimensions(cr);
        draw_base(cr);
        draw_fret_marks(cr);
        draw_frets(cr);
        draw_strings(cr);
        draw_marked_notes(cr);
        //stdout.printf("Draw called [END]."); stdout.flush();
        return false;
    }
    
   /**
    * Calculate some drawing dimensions
    * @param cr The drawing context for the widget
    **/
    private void calculate_dimensions(Cairo.Context cr) {
        //stdout.printf("Calculate dimensions [START]."); stdout.flush();
        width = get_allocated_width (); //total width for the widget
        height = get_allocated_height (); //total height for the widget

        grid_height = 0.8 * height;
        if(show_labels) {
            grid_width = 0.95 * width;
            cr.select_font_face("monospace", Cairo.FontSlant.NORMAL, 
                                Cairo.FontWeight.NORMAL);
            //TODO Fix this font size (Pango?)
            cr.set_font_size(0.05 * width); 
        }
        else
            grid_width = width; //all width used if no labels are displayed
            
        grid_x = width - grid_width; //grid start point (X)
        grid_y = (height - grid_height) / 2; //grid start point (Y)
        string_spacing = grid_height / (guitar_strings.size - 1); //segfault with glade
        fret_spacing = grid_width / fret_number;  
        fret_mark_radius = 0.5 * Math.fmin(fret_spacing / 2, string_spacing / 2);
        marked_note_radius = 0.7 * Math.fmin(fret_spacing / 2, string_spacing / 2);
        //stdout.printf("Calculate dimensions [END]."); stdout.flush();
    }

   /**
    * Draw grid background and theme-related stuff
    * @param cr The drawing context for the widget
    **/    
    private void draw_base(Cairo.Context cr) {
        cr.save();
        cr.set_source_rgba(grid_bg_color.red, grid_bg_color.green, 
                           grid_bg_color.blue, grid_bg_color.alpha);
        cr.rectangle(grid_x + fret_spacing, grid_y, grid_width, grid_height);
        cr.fill();
        cr.restore();
    }
    
    
   /**
    * Draw guitar strings according to its style properties
    * @param cr The drawing context for the widget
    **/
    private void draw_strings (Cairo.Context cr) {
        GuitarString str;
        string stringLabel;
        cr.set_line_width(2);
        cr.save();
        for(var i = 0; i < guitar_strings.size ; i++) {
            str = guitar_strings[i];
            cr.set_source_rgba(str.color.red, str.color.green, 
                               str.color.blue, str.color.alpha);
            var stringY = grid_y + i * string_spacing;
            cr.move_to (grid_x, stringY);
            if(!str.vibrate || !should_animate)
                cr.line_to (grid_x + width, stringY);
            else {
                var instant = Math.sin(animate_instant + 4 * str.vibrate_seed);
                var amplitude = instant * 0.1 * string_spacing;
                cr.curve_to (grid_x, stringY + amplitude, 
                             grid_x + width, stringY + amplitude,
                             grid_x + width, stringY);
            }
            cr.stroke();
            cr.set_source_rgba(0.0, 0.0, 0.0, 1.0);
            Cairo.TextExtents te;
            if (show_labels) {
                stringLabel = guitar_strings[i].note;
                if (!detailed_labels)
                    stringLabel = stringLabel[0:stringLabel.length - 1];
                cr.text_extents(stringLabel, out te);
                cr.move_to(grid_x - 0.5 - te.x_bearing - te.width, 
                           stringY + 0.5 - te.y_bearing - te.height / 2);
                cr.show_text(stringLabel);
            }
        }
        cr.restore();
    }
    
    
   /**
    * Draw guitar frets
    * @param cr The drawing context for the widget
    */  
    private void draw_frets(Cairo.Context cr) {
        cr.save();
        cr.set_source_rgba(fret_color.red, fret_color.green, 
                           fret_color.blue, fret_color.alpha);
        for(var j = 1; j < fret_number; j++) {
            var fretX = grid_x + j * fret_spacing;
            cr.move_to (fretX, grid_y);
            cr.line_to (fretX, grid_y + grid_height);
        }
        cr.stroke();
        cr.restore();
        if(!highlight_first_fret)
            return;
        cr.save ();
        cr.set_line_width (0.1 * fret_spacing);
        cr.move_to (grid_x + 0.9 * fret_spacing, grid_y);
        cr.line_to (grid_x + 0.9 * fret_spacing, grid_y + grid_height);
        cr.stroke ();
        cr.restore ();
    }
    
   /**
    * Draw fret marks
    * @param cr The drawing context for the widget
    */  
    private void draw_fret_marks(Cairo.Context cr) {
        if(fret_marks.size == 0)
            return;
        cr.save ();
        foreach (GuitarFretMark fm in fret_marks) {
            var p = fm.position;
            cr.set_source_rgba(fm.color.red, fm.color.green, 
                               fm.color.blue, fm.color.alpha);
            cr.arc (grid_x + (p + 0.5) * fret_spacing, grid_y + grid_height /2,
                    fret_mark_radius, 0, 2 * Math.PI);
        }
        cr.fill();
        cr.restore();
    }

    
   /**
    * Draw marked notes
    * @param cr The drawing context for the widget
    */  
    private void draw_marked_notes(Cairo.Context cr) {
        if(marked_notes.size == 0)
            return;
        cr.save ();
        foreach (var entry in marked_notes.entries) {
            var k = entry.key;
            var v = entry.value;
            cr.set_source_rgba(v.color.red, v.color.green, 
                               v.color.blue, v.color.alpha);
            var x = grid_x + (k.fret_index + 0.5) * fret_spacing;
            var y = grid_y + k.string_index * string_spacing;
            cr.move_to(x, y);
            cr.arc (x, y, marked_note_radius, 0, 2 * Math.PI);
            cr.fill();
        }
        cr.restore();
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
}

}
