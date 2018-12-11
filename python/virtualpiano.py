#!/usr/bin/env python3

import gi
gi.require_version('Gtk', '3.0')
gi.require_version('Gdk', '3.0')
gi.require_version('GtkMusic', '0.6')

import fluidsynth
from gi.repository import Gtk, Gdk, GtkMusic

HIGHLIGHT_COLOR = Gdk.RGBA(*[0.5, 0.5, 0.5, 1.0])

def note_pressed(widget, event, midi_code):
    print('Note %d pressed' % midi_code)
    fs.noteon(0, midi_code, 100)
    widget.mark_midi(midi_code, HIGHLIGHT_COLOR)
    widget.redraw()

def note_released(widget, event, midi_code):
    print('Note %d released' % midi_code)
    fs.noteoff(0, midi_code)
    widget.unmark_midi(midi_code)
    widget.redraw()


win = Gtk.Window()
piano = GtkMusic.Piano.new()  # correct way to instantiate the widget
piano.set_size_request(480, 160)

fs = fluidsynth.Synth()
fs.start(driver='alsa', device='hw:0')  # change to meet to your settings
sfid = fs.sfload('/usr/share/sounds/sf2/FluidR3_GM.sf2')  # your soundfont here
fs.program_select(0, sfid, 0, 0)

piano.add_events(Gdk.EventMask.BUTTON_PRESS_MASK | 
                 Gdk.EventMask.BUTTON_RELEASE_MASK)
piano.connect('note_pressed',  note_pressed)
piano.connect('note_released', note_released)
win.connect('destroy', Gtk.main_quit)

win.add(piano)

win.show_all()
try:
    Gtk.main()
finally:
    fs.delete()