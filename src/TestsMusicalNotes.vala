using GtkMusic;

int main(string[] args) {
    string currNote;
    ushort currMidi;
    for(ushort i = 21; i < 34; i++) {
        stdout.printf("MIDI %u : ", i); stdout.flush();

        try {
            currNote = MusicalNotes.get_note_from_midi_code(i);
            stdout.printf("%s", currNote);
        }
        catch (MusicalNoteError m) {
            stdout.printf("Invalid MIDI code\n"); stdout.flush();
            continue;
        }

        try {
            currMidi = MusicalNotes.get_note_as_midi_code(currNote);
            stdout.printf(" (%u) \n", currMidi);
        }
        catch (MusicalNoteError m) {
            stdout.printf("Invalid note\n"); stdout.flush();
        }
    }
    return 0;
}
