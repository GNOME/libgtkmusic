using Gtk;
using Gee;

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
    public string note; 
    
    /**
     * Whether this note should be vibrating (sinusoidal movement animation) 
     */
    public bool vibrate = false;
    
    /**
     * A random generator seed (vibration animation phase difference) 
     */
    public double vibrateSeed;  //should be private with getter ?
    
    /**
     * Guitar string color as a RGBA array of floats 
     */
    public float[] color = {0.1f, 0.1f, 0.1f, 1.0f};
    
    /**
     * Label color as a RGBA array of floats 
     */
    public float[] labelColor = {0.0f, 0.0f, 0.0f, 1.0f};
    
    public GuitarString(string note) {
        this.note = note;
        vibrateSeed = Random.next_double();
    }
}

/**
 * A fret mark used to highlight a fret
 **/
public class GuitarFretMark {
    /**
     * The fret mark position 
     */
    public ushort position;
    
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
    public Style style;
    
    /** 
     * The fret mark color as an RGBA array of floats 
     */
    public float[] color = {0.8f, 0.8f, 0.8f, 1.0f};
    
    public GuitarFretMark(ushort position) {
        this.position = position;
    }
}

/**
 * A guitar position, composed by the string index and the fret index
 **/
public class GuitarPosition {

    /** 
     * The guitar string index [0,5] associated to this guitar position 
     */
    public ushort stringIndex;
    
    /** 
     * The fret index associated to this guitar position 
     */
    public ushort fretIndex;
    
    public GuitarPosition(ushort stringIndex, ushort fretIndex) {
        this.stringIndex = stringIndex;
        this.fretIndex = fretIndex;
    }
      
    public static uint hash_func(GuitarPosition key) {
        return (13 + key.stringIndex) * 23 + key.fretIndex;
    }
    
    public static bool equal_func(GuitarPosition a, GuitarPosition b) {
        if(a.stringIndex == b.stringIndex && a.fretIndex == b.fretIndex)
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
     * @param guitar The Guitar who trigerred the event
     * @param event The Gdk low level event object
     * @param pos The GuitarPosition (string and fret) of the pressed note
     */
    public signal void note_pressed (Guitar guitar, Gdk.EventButton event,
                                     GuitarPosition pos);
                              
    /**
     * Signal emitted when a note has been released (mouse button released)
     * @param guitar The Guitar who trigerred the event
     * @param event The Gdk low level event object
     * @param pos The GuitarPosition (string and fret) of the released note
     */
    public signal void note_released (Guitar guitar, Gdk.EventButton event,
                                      GuitarPosition pos);
    
    //=========================================================================
    //Properties
    //=========================================================================
    
    //Behavior properties
    
    /**
     * Render string labels (e.g.: EADGBE) 
     */
    public bool showLabels = true;
    
    /**
     * Show octaves in labels (e.g.: E4) 
     */
    public bool detailedLabels = false;
    
    /** 
     * Draw additional line in 1st fret 
     */
    public bool highlightFirstFret = true;
    
    /** 
     * Auto-redraw when a note is added (disable for manual management) 
     */
    public bool autoUpdate = true; 
    
    /** 
     * Whether the guitar should be animated (string vibrations)
     */
    private bool shouldAnimate = false;
    
    //Grid properties

    /** 
     * Number of frets 
     */
    public ushort fretNumber = 17;

    //public float[] gridBgColor = {0.57f, 0.39f, 0.30f, 1.0f};

    /**
     * Grid background color as a RGBA array of floats
     */
    public float[] gridBgColor = {0.486f, 0.309f, 0.251f, 1.0f};

    /** 
     * Fret color as a RGBA array of floats 
     */
    public float[] fretColor = {0.6f, 0.6f, 0.6f, 1.0f};

    /** 
     * Collection of strings 
     */
    public ArrayList<GuitarString> guitarStrings;

    /**
     * Collection of fret marks 
     */
    public HashSet<GuitarFretMark> fretMarks;
    
    //Advanced style properties
    //TODO :: Guitar styles (classical, electrical, guitar hero, music school)
    
    //=========================================================================
    //Marked Notes
    //=========================================================================
    
    /** 
     * Style for marked notes 
     */
    public class MarkedNoteStyle {
        public float[] color = {0.0f, 0.0f, 0.0f, 1.0f};
        public MarkedNoteStyle(float[] color) {
            this.color = color;
        }
    }

    /** 
     * Marked notes dictionary (position and mark style) 
     */
    public HashMap<GuitarPosition, MarkedNoteStyle> markedNotes;
    
    //=========================================================================
    //Private properties
    //=========================================================================
    
    //Internal variables (really private)
    private double width;
    private double height;
    private double gridWidth;
    private double gridHeight;
    private double gridX;
    private double gridY;
    private double stringSpacing;
    private double fretSpacing;
    private double fretMarkRadius;
    private double markedNoteRadius;
    private float animateInstant = 0;
    //Defaults
    private string[] defaultStrings = {"E2", "A2", "D3", "G3", "B3", "E4"};
    private ushort[] defaultFretMarks = {1, 3, 5, 7, 9, 12, 15, 17};
    
    //=========================================================================
    //Methods
    //=========================================================================
    
   /**
    * Create a new Guitar widget, which minimum size is defined to 170x60
    **/
    public Guitar () {
        //stdout.printf("Creating guitar [START]..."); stdout.flush();
        add_events (Gdk.EventMask.BUTTON_PRESS_MASK
                  | Gdk.EventMask.BUTTON_RELEASE_MASK);
        set_size_request (170, 60);  //minimum widget size
        guitarStrings = new ArrayList<GuitarString> ();
        fretMarks = new HashSet<GuitarFretMark> ();
        markedNotes = new HashMap<GuitarPosition, MarkedNoteStyle> 
                          ( (Gee.HashDataFunc?) GuitarPosition.hash_func,
                            (Gee.EqualDataFunc?) GuitarPosition.equal_func );
        foreach(string s in defaultStrings)
            guitarStrings.add(new GuitarString(s));
        foreach(ushort i in defaultFretMarks)
            fretMarks.add(new GuitarFretMark(i));
        //stdout.printf("Creating guitar [END]..."); stdout.flush();    
    }
    
    //=========================================================================
    //Animation related
    //=========================================================================
    
    /**
     * Start the animation on strings set to vibrate
     */ 
    public void start_animation() {
        shouldAnimate = true;
        Timeout.add (10, update_animation);
    }
    
    /**
     * Stop the string vibration animation
     */
    public void stop_animation() {
        shouldAnimate = false;
        animateInstant = 0;
    }
    
    /**
     * Draw a new frame of the vibration animation
     */
    private bool update_animation() {
        animateInstant += 0.3f;
        redraw();
        return shouldAnimate;
    }
    
    //====Marking-related======================================================
    
   /**
    * Highlight a position (string and fret) in the instrument
    * @param stringIndex The string number (top string equals to 0)
    * @param fretIndex The fret number
    **/
    public void mark_position(ushort stringIndex, ushort fretIndex,
                              float[] color = {0.0f, 0.0f, 0.0f, 1.0f}) {
        var key = new GuitarPosition(stringIndex, fretIndex);
        markedNotes[key] = new MarkedNoteStyle(color);
        if(autoUpdate)
            redraw();
    }

   /**
    * Remove the mark of a position (string and fret) in the instrument
    * @param stringIndex The string number (topmost string equals to 0)
    * @param fretIndex The fret number
    **/    
    public void unmark_position(ushort stringIndex, ushort fretIndex) {
        var key = new GuitarPosition(stringIndex, fretIndex);
        if(markedNotes.has_key(key))
            markedNotes.unset(key);
        if(autoUpdate)
            redraw();
    }
    
   /**
    * Remove all marked notes in the Guitar view
    **/ 
    public void unmark_all() {
        markedNotes.clear();
        if(autoUpdate)
            redraw();
    }
    
   /**
    * Highlight all positions corresponding to a note
    * @param note A musical note in scientific notation (examples: F#4 , C)
    **/
    public void mark_note(string note, 
                          float[] color = {0.0f, 0.0f, 0.0f, 1.0f}) {
        bool oldAutoUpdate = autoUpdate;
        var positions = find_positions(note);
        if(positions == null)
            return;
        foreach(GuitarPosition k in positions) {
            mark_position(k.stringIndex, k.fretIndex, color);
        }
        autoUpdate = oldAutoUpdate;
        if(autoUpdate)
            redraw();
    }
    
   /**
    * Remove the marks in all positions corresponding to a note
    * @param note A musical note in scientific notation (examples: F#4 , C)
    **/    
    public void unmark_note(string note) {
        bool oldAutoUpdate = autoUpdate;
        var positions = find_positions(note);
        if(positions == null)
            return;
        foreach(GuitarPosition k in positions) {
            unmark_position(k.stringIndex, k.fretIndex);
        }
        autoUpdate = oldAutoUpdate;
        if(autoUpdate)
            redraw();
    }
    
    //=====Coordinates and units related (Note <--> GuitarPosition <--> x,y)===
    
    /**
     * Compute the fret index to accomplish a given note in a given string
     * @param stringIndex The guitar string index
     * @param note The musical note in scientific notation
     * @return The position where the note can be found or -1
     **/
    public short note_position_in_string(ushort stringIndex, string note) {
        string firstNote = guitarStrings[stringIndex].note;
        var midiA = MusicalNotes.get_note_as_midi_code(firstNote);
        var midiB = MusicalNotes.get_note_as_midi_code(note);
        short result = (short) (midiB - midiA);
        if(result > fretNumber)
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

        short fretIndex;
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
            for(var s = 0 ; s < guitarStrings.size ; s++) {
                fretIndex = note_position_in_string(s, n);
                if(fretIndex >= 0)
                    validPositions.add(new GuitarPosition(s, fretIndex));
            }
        }
        return validPositions;
    }
    
   /**
    * Get a MIDI code from a guitar position
    **/
    public ushort position_to_midi(GuitarPosition position) {
        string first_note = guitarStrings[position.stringIndex].note;
        ushort midi = MusicalNotes.get_note_as_midi_code(first_note);
        midi += position.fretIndex;
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
        x -= gridX;
        y -= gridY;
        
        //Normalized offsets
        double fretOffset = (double) (x % fretSpacing) / fretSpacing;
        double stringOffset = (double) (y % stringSpacing) / stringSpacing;
        
        //Checking offsets (from fret center for x, from string base for y)
        if(Math.fabs(fretOffset - 0.5) > x_tolerance || //fret center
           (stringOffset < (1 - y_tolerance) && stringOffset > y_tolerance) )
           return null;
        
        ushort fretIndex = (ushort) (x/fretSpacing);
        ushort stringIndex = (ushort) (y/stringSpacing);
        if(stringOffset > (1 - y_tolerance)) //in order to get nearest string
            stringIndex += 1;
        
        return new GuitarPosition(stringIndex, fretIndex);
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
            note_pressed(this, event, pos);
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
            note_released(this, event, pos);
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
        calculate_dimensions(cr); //segfault with glade
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

        gridHeight = 0.8 * height;
        if(showLabels) {
            gridWidth = 0.95 * width;
            cr.select_font_face("monospace", Cairo.FontSlant.NORMAL, 
                                Cairo.FontWeight.NORMAL);
            //TODO Fix this font size (Pango?)
            cr.set_font_size(0.05 * width); 
        }
        else
            gridWidth = width; //all width used if no labels are displayed
            
        gridX = width - gridWidth; //grid start point (X)
        gridY = (height - gridHeight) / 2; //grid start point (Y)
        stringSpacing = gridHeight / (guitarStrings.size - 1); //segfault with glade
        fretSpacing = gridWidth / fretNumber;  
        fretMarkRadius = 0.5 * Math.fmin(fretSpacing / 2, stringSpacing / 2);
        markedNoteRadius = 0.7 * Math.fmin(fretSpacing / 2, stringSpacing / 2);
        //stdout.printf("Calculate dimensions [END]."); stdout.flush();
    }

   /**
    * Draw grid background and theme-related stuff
    * @param cr The drawing context for the widget
    **/    
    private void draw_base(Cairo.Context cr) {
        cr.save();
        cr.set_source_rgba(gridBgColor[0], gridBgColor[1], 
                           gridBgColor[2], gridBgColor[3]);
        cr.rectangle(gridX + fretSpacing, gridY, gridWidth, gridHeight);
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
        for(var i = 0; i < guitarStrings.size ; i++) {
            str = guitarStrings[i];
            cr.set_source_rgba(str.color[0], str.color[1], 
                               str.color[2], str.color[3]);
            var stringY = gridY + i * stringSpacing;
            cr.move_to (gridX, stringY);
            if(!str.vibrate || !shouldAnimate)
                cr.line_to (gridX + width, stringY);
            else {
                var instant = Math.sin(animateInstant + 4 * str.vibrateSeed);
                var amplitude = instant * 0.1 * stringSpacing;
                cr.curve_to (gridX, stringY + amplitude, 
                             gridX + width, stringY + amplitude,
                             gridX + width, stringY);
            }
            cr.stroke();
            cr.set_source_rgba(0.0, 0.0, 0.0, 1.0);
            Cairo.TextExtents te;
            if (showLabels) {
                stringLabel = guitarStrings[i].note;
                if (!detailedLabels)
                    stringLabel = stringLabel[0:stringLabel.length - 1];
                cr.text_extents(stringLabel, out te);
                cr.move_to(gridX - 0.5 - te.x_bearing - te.width, 
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
        cr.set_source_rgba(fretColor[0], fretColor[1], 
                           fretColor[2], fretColor[3]);
        for(var j = 1; j < fretNumber; j++) {
            var fretX = gridX + j * fretSpacing;
            cr.move_to (fretX, gridY);
            cr.line_to (fretX, gridY + gridHeight);
        }
        cr.stroke();
        cr.restore();
        if(!highlightFirstFret)
            return;
        cr.save ();
        cr.set_line_width (0.1 * fretSpacing);
        cr.move_to (gridX + 0.9 * fretSpacing, gridY);
        cr.line_to (gridX + 0.9 * fretSpacing, gridY + gridHeight);
        cr.stroke ();
        cr.restore ();
    }
    
   /**
    * Draw fret marks
    * @param cr The drawing context for the widget
    */  
    private void draw_fret_marks(Cairo.Context cr) {
        if(fretMarks.size == 0)
            return;
        cr.save ();
        foreach (GuitarFretMark fm in fretMarks) {
            var p = fm.position;
            cr.set_source_rgba(fm.color[0], fm.color[1], 
                               fm.color[2], fm.color[3]);
            cr.arc (gridX + (p + 0.5) * fretSpacing, gridY + gridHeight /2,
                    fretMarkRadius, 0, 2 * Math.PI);
        }
        cr.fill();
        cr.restore();
    }

    
   /**
    * Draw marked notes
    * @param cr The drawing context for the widget
    */  
    private void draw_marked_notes(Cairo.Context cr) {
        if(markedNotes.size == 0)
            return;
        cr.save ();
        foreach (var entry in markedNotes.entries) {
            var k = entry.key;
            var v = entry.value;
            cr.set_source_rgba(v.color[0], v.color[1], v.color[2], v.color[3]);
            var x = gridX + (k.fretIndex + 0.5) * fretSpacing;
            var y = gridY + k.stringIndex * stringSpacing;
            cr.move_to(x, y);
            cr.arc (x, y, markedNoteRadius, 0, 2 * Math.PI);
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
        window.process_updates (true);
    }
}

}
