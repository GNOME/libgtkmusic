using Gtk;
using Gee;

namespace GtkMusic {

/**
 * Exception for invalid notes
 **/
public errordomain MusicalNoteError {
    INVALID_NOTE,
    INVALID_MIDI,
    ALREADY_COMPLETE
}

public class MusicalNotes {
    /**
     * Musical notes, without octaves
     **/
    public const string[] note_names = { "C", "C#", "D", "D#", "E", "F", 
                                      "F#", "G", "G#", "A", "A#", "B" };
    
    /**
     * All standard diatonic intervals, in order.
     **/
    public enum 
    DiatonicIntervals {
        UNISON,
        MINOR_SECOND,
        MAJOR_SECOND,
        MINOR_THIRD,
        MAJOR_THIRD,
        PERFECT_FOURTH,
        DIMINISHED_FIFTH,
        PERFECT_FIFTH,
        MINOR_SIXTH,
        MAJOR_SIXTH,
        MINOR_SEVENTH,
        MAJOR_SEVENTH,
        PERFECT_OCTAVE
    }
    
   /**
    * Checks whether a note is valid
    * @param note The note in scientific notation (as in E3)
    * @return True if the note is valid or false otherwise
    **/
    public static bool validate(string note) {
        try {
            get_note_as_midi_code(note);
            return true;
        }
        catch(MusicalNoteError e) {
            return false;
        }
    }

   /**
    * Checks whether a string represents a note without octave
    * @param needle The string to be checked
    * @return True if it's a note without octave or false otherwise
    **/
    public static bool is_incomplete(string needle) {
        for(var i = 0 ; i < note_names.length ; i++)
            if(note_names[i] == needle)
                return true;
        return false;
    }
    
    /**
     * Returns all notes with a given name (map C to => C0, C1, C2, ...);
     * @param incompleteNote A note without its octave component
     * @return A set of all possible notes with this name
     **/
    public static HashSet<string> make(string incompleteNote) 
           throws MusicalNoteError {

        //Asserting that the note doesn't have the octave component
        if(!is_incomplete(incompleteNote))
            throw new MusicalNoteError.ALREADY_COMPLETE("Note is complete!");
        ushort start = 1;
        ushort end = 7;
       
        //Handling octave limits
        if(incompleteNote == "C")
            end = 8;
        else if(incompleteNote == "A" || incompleteNote == "A#" || 
                incompleteNote == "B")
            start = 0;

        var notes = new HashSet<string> ();
        for(ushort i = start ; i <= end ; i++)
            notes.add(incompleteNote + i.to_string());
        return notes;
    }
    
   /**
    * Gets the note's MIDI code
    *
    * Algorithm:
    * A note, such as C#3 is decomposed into:
    *  - the octave (3)
    *  - the note name (C#)
    * Each note name receives an index in the range 0..11 .
    * The index is used as the "LSB" part of the note number and the octave
    * is used as the "MSB" part of the number.
    * An offset (12) is added so that A0=21
    * A constraint is added so that the note is between 21 (A0) and 108 (C8)
    *
    * @param note The note in scientific notation (with octave)
    * @return The associated MIDI code
    **/
    public static short get_note_as_midi_code(string note) 
           throws MusicalNoteError {
        //Number components
        short high = -1;
        short low = -1;
        
        //Used for validation
        char octave;
        string note_name;

        //=====================================================================
        //Parsing note
        //=====================================================================
        if(note.length < 2)                     //Note minimum length: 2
            throw new MusicalNoteError.INVALID_NOTE("Invalid note length!");
        octave = note[note.length - 1];         //Last character is octave
        if(!octave.isdigit())                   //Octave is a digit
            throw new MusicalNoteError.INVALID_NOTE("Invalid octave!");
        high = (short) octave.digit_value();            //Saving "MSB"
        note_name = note[0 : note.length - 1];
        for(var i = 0 ; i < note_names.length ; i++) {
            if(note_names[i] == note_name) {
                low = i;                     //Getting "LSB"
                break;
            }
        }
        if(low == -1)                       //Invalid note name
            return -1;

        var midi_code = (high * 12 + low) + 12;
        if(midi_code > 108 || midi_code < 21) //Out of range
            throw new MusicalNoteError.INVALID_NOTE("Out of range (A0 --> C8)");  
        return midi_code;
    }


    /**
    * Gets the note's string from its MIDI code
    *
    * This functions performs the inverse procedure of getting a MIDI code from
    * a scientific notation note string:
    * 
    * 1. Subtract 18 from the MIDI code
    * 2. Get the integer part of the division by 12 as the octave
    * 3. Get the modulus division as the note index
    * 4. Construct note indexing the note_names list and adding the octave
    *
    * @param note The note valid MIDI code
    * @return The note as a string or ""
    **/
    public static string get_note_from_midi_code(ushort midi) 
           throws MusicalNoteError {

        if(midi > 108 || midi < 21)
            throw new MusicalNoteError.INVALID_MIDI("Not in range 21..108");
            
        midi -= 12;
        ushort octave = (ushort) (midi / 12);
        ushort note_index = (ushort) (midi % 12);
        string note = note_names[note_index];
        note += octave.to_string();
        return note;
    }
    
    /**
     * Checks whether a given MIDI code is an accidental note (C#, D#, ...)
     * @param midi The MIDI code of a note
     * @return Whether the note has an accidental
     **/
    public static bool midi_is_accident(ushort midi) {
        switch(midi % 12) {
                case 1:
                case 3:
                case 6:
                case 8:
                case 10:
                    return true;
                default:
                    return false;
            }      
    }
    
    /**
     * Checks whether a given MIDI code is different of E or B
     * @param midi The MIDI code of a note
     * @return Whether the note can have an accident (thus, neither E nor B)
     **/
    public static bool midi_can_have_accident(ushort midi) {
        ushort norm_midi = midi % 12;
        return (norm_midi != 4 && norm_midi != 11);
    }
}

}
