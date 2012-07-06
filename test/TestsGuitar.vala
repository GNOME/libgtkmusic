using Gtk;
using GtkMusic;

void note_pressed_callback(Widget widget, Gdk.EventButton event, 
                           GuitarPosition pos) {
    var guitar = widget as Guitar;
    stdout.printf("You clicked a %s!\n", guitar.position_to_note(pos));
    stdout.flush();
    if(event.button == 1) //left-click
        guitar.mark_position(pos.stringIndex, pos.fretIndex);
    else
        guitar.unmark_position(pos.stringIndex, pos.fretIndex);
}

int main(string[] args) {
    Gtk.init (ref args);
    var window = new Window ();
    var guitar = new Guitar ();
    guitar.note_pressed.connect(note_pressed_callback);
    guitar.guitarStrings[0].vibrate = true;
    guitar.guitarStrings[5].vibrate = true;
    guitar.start_animation();
    guitar.mark_position(0, 0, {0.4f, 0.0f, 0.0f, 1.0f});
    guitar.mark_position(1, 1);
    guitar.mark_position(2, 1);
    guitar.mark_position(3, 0);
    guitar.mark_position(5, 3);
    guitar.mark_note("A3", {0.0f, 0.4f, 0.0f, 1.0f});
    guitar.mark_note("C", {0.0f, 0.0f, 0.4f, 0.7f});
    window.add (guitar);
    window.destroy.connect (Gtk.main_quit);
    window.show_all ();
    Gtk.main ();
    return 0;
}