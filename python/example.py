#!/usr/bin/env python3
import gi
gi.require_version('Gtk', '3.0')
gi.require_version('Gdk', '3.0')
gi.require_version('GtkMusic', '0.5')

from gi.repository import Gtk, Gdk, GtkMusic

def note_pressed(widget, event, midi_code):
        print('You pressed the note with MIDI code %d!' % midi_code)

win = Gtk.Window()
piano = GtkMusic.Piano.new()  # correct way to instantiate the widget

piano.add_events(Gdk.EventMask.BUTTON_PRESS_MASK)
piano.connect('note_pressed',  note_pressed)
win.connect('destroy', Gtk.main_quit)

win.add(piano)

win.show_all()
Gtk.main()