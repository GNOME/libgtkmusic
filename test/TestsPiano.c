/* TestsPiano.c generated by valac 0.18.1, the Vala compiler
 * generated from TestsPiano.vala, do not modify */


#include <glib.h>
#include <glib-object.h>
#include <gtk/gtk.h>
#include <gdk/gdk.h>
#include <gtkmusic.h>
#include <stdio.h>
#include <float.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))



void note_pressed_callback (GtkWidget* widget, GdkEventButton* event, gint key);
gint _vala_main (gchar** args, int args_length1);
static void _note_pressed_callback_gtk_music_piano_note_pressed (GtkMusicPiano* _sender, GtkWidget* widget, GdkEventButton* event, gint midi_note, gpointer self);
static void _gtk_main_quit_gtk_widget_destroy (GtkWidget* _sender, gpointer self);


static gpointer _g_object_ref0 (gpointer self) {
	return self ? g_object_ref (self) : NULL;
}


void note_pressed_callback (GtkWidget* widget, GdkEventButton* event, gint key) {
	GtkWidget* _tmp0_;
	GtkMusicPiano* _tmp1_;
	GtkMusicPiano* piano;
	FILE* _tmp2_;
	gint _tmp3_;
	FILE* _tmp4_;
	GdkEventButton _tmp5_;
	guint _tmp6_;
	g_return_if_fail (widget != NULL);
	g_return_if_fail (event != NULL);
	_tmp0_ = widget;
	_tmp1_ = _g_object_ref0 (G_TYPE_CHECK_INSTANCE_TYPE (_tmp0_, GTK_MUSIC_TYPE_PIANO) ? ((GtkMusicPiano*) _tmp0_) : NULL);
	piano = _tmp1_;
	_tmp2_ = stdout;
	_tmp3_ = key;
	fprintf (_tmp2_, "You clicked key %d  ", _tmp3_);
	_tmp4_ = stdout;
	fflush (_tmp4_);
	_tmp5_ = *event;
	_tmp6_ = _tmp5_.button;
	if (_tmp6_ == ((guint) 1)) {
		GtkMusicPiano* _tmp7_;
		gint _tmp8_;
		gfloat* _tmp9_ = NULL;
		gfloat* _tmp10_;
		gint _tmp10__length1;
		_tmp7_ = piano;
		_tmp8_ = key;
		_tmp9_ = g_new0 (gfloat, 4);
		_tmp9_[0] = 0.0f;
		_tmp9_[1] = 0.0f;
		_tmp9_[2] = 0.5f;
		_tmp9_[3] = 1.0f;
		_tmp10_ = _tmp9_;
		_tmp10__length1 = 4;
		gtk_music_piano_mark_midi (_tmp7_, (gushort) _tmp8_, _tmp10_, 4);
		_tmp10_ = (g_free (_tmp10_), NULL);
	} else {
		GtkMusicPiano* _tmp11_;
		gint _tmp12_;
		_tmp11_ = piano;
		_tmp12_ = key;
		gtk_music_piano_unmark_midi (_tmp11_, (gushort) _tmp12_);
	}
	_g_object_unref0 (piano);
}


static void _note_pressed_callback_gtk_music_piano_note_pressed (GtkMusicPiano* _sender, GtkWidget* widget, GdkEventButton* event, gint midi_note, gpointer self) {
	note_pressed_callback (widget, event, midi_note);
}


static void _gtk_main_quit_gtk_widget_destroy (GtkWidget* _sender, gpointer self) {
	gtk_main_quit ();
}


gint _vala_main (gchar** args, int args_length1) {
	gint result = 0;
	GtkWindow* _tmp0_;
	GtkWindow* window;
	GtkMusicPiano* _tmp1_;
	GtkMusicPiano* piano;
	gfloat* _tmp2_ = NULL;
	gfloat* _tmp3_;
	gint _tmp3__length1;
	gfloat* _tmp4_ = NULL;
	gfloat* _tmp5_;
	gint _tmp5__length1;
	gfloat* _tmp6_ = NULL;
	gfloat* _tmp7_;
	gint _tmp7__length1;
	gfloat* _tmp8_ = NULL;
	gfloat* _tmp9_;
	gint _tmp9__length1;
	gtk_init (&args_length1, &args);
	_tmp0_ = (GtkWindow*) gtk_window_new (GTK_WINDOW_TOPLEVEL);
	g_object_ref_sink (_tmp0_);
	window = _tmp0_;
	_tmp1_ = gtk_music_piano_new ();
	g_object_ref_sink (_tmp1_);
	piano = _tmp1_;
	g_signal_connect (piano, "note-pressed", (GCallback) _note_pressed_callback_gtk_music_piano_note_pressed, NULL);
	_tmp2_ = g_new0 (gfloat, 4);
	_tmp2_[0] = 0.0f;
	_tmp2_[1] = 0.0f;
	_tmp2_[2] = 0.5f;
	_tmp2_[3] = 1.0f;
	_tmp3_ = _tmp2_;
	_tmp3__length1 = 4;
	gtk_music_piano_mark_midi (piano, (gushort) 50, _tmp3_, 4);
	_tmp3_ = (g_free (_tmp3_), NULL);
	_tmp4_ = g_new0 (gfloat, 4);
	_tmp4_[0] = 0.4f;
	_tmp4_[1] = 0.0f;
	_tmp4_[2] = 0.0f;
	_tmp4_[3] = 1.0f;
	_tmp5_ = _tmp4_;
	_tmp5__length1 = 4;
	gtk_music_piano_mark_midi (piano, (gushort) 51, _tmp5_, 4);
	_tmp5_ = (g_free (_tmp5_), NULL);
	_tmp6_ = g_new0 (gfloat, 4);
	_tmp6_[0] = 0.0f;
	_tmp6_[1] = 0.0f;
	_tmp6_[2] = 0.5f;
	_tmp6_[3] = 1.0f;
	_tmp7_ = _tmp6_;
	_tmp7__length1 = 4;
	gtk_music_piano_mark_midi (piano, (gushort) 36, _tmp7_, 4);
	_tmp7_ = (g_free (_tmp7_), NULL);
	_tmp8_ = g_new0 (gfloat, 4);
	_tmp8_[0] = 0.0f;
	_tmp8_[1] = 0.0f;
	_tmp8_[2] = 0.5f;
	_tmp8_[3] = 1.0f;
	_tmp9_ = _tmp8_;
	_tmp9__length1 = 4;
	gtk_music_piano_mark_midi (piano, (gushort) 59, _tmp9_, 4);
	_tmp9_ = (g_free (_tmp9_), NULL);
	gtk_container_add ((GtkContainer*) window, (GtkWidget*) piano);
	g_signal_connect ((GtkWidget*) window, "destroy", (GCallback) _gtk_main_quit_gtk_widget_destroy, NULL);
	gtk_widget_show_all ((GtkWidget*) window);
	gtk_main ();
	result = 0;
	_g_object_unref0 (piano);
	_g_object_unref0 (window);
	return result;
}


int main (int argc, char ** argv) {
	g_type_init ();
	return _vala_main (argv, argc);
}



