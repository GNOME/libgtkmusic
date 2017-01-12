using Gtk;
using GtkMusic;

void note_pressed_callback(Piano piano, Gdk.EventButton event, int key) {
    stdout.printf("You clicked key %d  \n", key); stdout.flush();
    if(event.button == 1)
        piano.mark_midi((ushort) key);
    else
        piano.unmark_midi((ushort) key);
}

int main(string[] args) {
    Gtk.init (ref args);
    var window = new Window ();
    var piano = new Piano ();
    piano.note_pressed.connect(note_pressed_callback);
    piano.mark_midi(50);
    piano.mark_midi(51, {0.4f, 0.0f, 0.0f, 1.0f});
    piano.mark_midi(36);
    piano.mark_midi(59);
    window.add(piano);
    window.destroy.connect (Gtk.main_quit);
    window.show_all ();
    Gtk.main ();
    return 0;
}
