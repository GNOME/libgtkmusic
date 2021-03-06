/* MusicalNotes.c generated by valac 0.18.1, the Vala compiler
 * generated from MusicalNotes.vala, do not modify */


#include <glib.h>
#include <glib-object.h>
#include <stdlib.h>
#include <string.h>
#include <gee.h>
#include <gobject/gvaluecollector.h>


#define GTK_MUSIC_TYPE_MUSICAL_NOTES (gtk_music_musical_notes_get_type ())
#define GTK_MUSIC_MUSICAL_NOTES(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), GTK_MUSIC_TYPE_MUSICAL_NOTES, GtkMusicMusicalNotes))
#define GTK_MUSIC_MUSICAL_NOTES_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), GTK_MUSIC_TYPE_MUSICAL_NOTES, GtkMusicMusicalNotesClass))
#define GTK_MUSIC_IS_MUSICAL_NOTES(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GTK_MUSIC_TYPE_MUSICAL_NOTES))
#define GTK_MUSIC_IS_MUSICAL_NOTES_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), GTK_MUSIC_TYPE_MUSICAL_NOTES))
#define GTK_MUSIC_MUSICAL_NOTES_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), GTK_MUSIC_TYPE_MUSICAL_NOTES, GtkMusicMusicalNotesClass))

typedef struct _GtkMusicMusicalNotes GtkMusicMusicalNotes;
typedef struct _GtkMusicMusicalNotesClass GtkMusicMusicalNotesClass;
typedef struct _GtkMusicMusicalNotesPrivate GtkMusicMusicalNotesPrivate;

#define GTK_MUSIC_MUSICAL_NOTES_TYPE_DIATONIC_INTERVALS (gtk_music_musical_notes_diatonic_intervals_get_type ())
#define _g_error_free0(var) ((var == NULL) ? NULL : (var = (g_error_free (var), NULL)))
#define _g_free0(var) (var = (g_free (var), NULL))
#define _g_object_unref0(var) ((var == NULL) ? NULL : (var = (g_object_unref (var), NULL)))
typedef struct _GtkMusicParamSpecMusicalNotes GtkMusicParamSpecMusicalNotes;

/**
 * Exception for invalid notes
 **/
typedef enum  {
	GTK_MUSIC_MUSICAL_NOTE_ERROR_INVALID_NOTE,
	GTK_MUSIC_MUSICAL_NOTE_ERROR_INVALID_MIDI,
	GTK_MUSIC_MUSICAL_NOTE_ERROR_ALREADY_COMPLETE
} GtkMusicMusicalNoteError;
#define GTK_MUSIC_MUSICAL_NOTE_ERROR gtk_music_musical_note_error_quark ()
struct _GtkMusicMusicalNotes {
	GTypeInstance parent_instance;
	volatile int ref_count;
	GtkMusicMusicalNotesPrivate * priv;
};

struct _GtkMusicMusicalNotesClass {
	GTypeClass parent_class;
	void (*finalize) (GtkMusicMusicalNotes *self);
};

typedef enum  {
	GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_UNISON,
	GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MINOR_SECOND,
	GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MAJOR_SECOND,
	GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MINOR_THIRD,
	GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MAJOR_THIRD,
	GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_PERFECT_FOURTH,
	GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_DIMINISHED_FIFTH,
	GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_PERFECT_FIFTH,
	GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MINOR_SIXTH,
	GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MAJOR_SIXTH,
	GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MINOR_SEVENTH,
	GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MAJOR_SEVENTH,
	GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_PERFECT_OCTAVE
} GtkMusicMusicalNotesDiatonicIntervals;

struct _GtkMusicParamSpecMusicalNotes {
	GParamSpec parent_instance;
};


static gpointer gtk_music_musical_notes_parent_class = NULL;

GQuark gtk_music_musical_note_error_quark (void);
gpointer gtk_music_musical_notes_ref (gpointer instance);
void gtk_music_musical_notes_unref (gpointer instance);
GParamSpec* gtk_music_param_spec_musical_notes (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags);
void gtk_music_value_set_musical_notes (GValue* value, gpointer v_object);
void gtk_music_value_take_musical_notes (GValue* value, gpointer v_object);
gpointer gtk_music_value_get_musical_notes (const GValue* value);
GType gtk_music_musical_notes_get_type (void) G_GNUC_CONST;
enum  {
	GTK_MUSIC_MUSICAL_NOTES_DUMMY_PROPERTY
};
GType gtk_music_musical_notes_diatonic_intervals_get_type (void) G_GNUC_CONST;
gboolean gtk_music_musical_notes_validate (const gchar* note);
gushort gtk_music_musical_notes_get_note_as_midi_code (const gchar* note, GError** error);
gboolean gtk_music_musical_notes_is_incomplete (const gchar* needle);
GeeHashSet* gtk_music_musical_notes_make (const gchar* incompleteNote, GError** error);
gchar* gtk_music_musical_notes_get_note_from_midi_code (gushort midi, GError** error);
gboolean gtk_music_musical_notes_midi_is_accident (gushort midi);
gboolean gtk_music_musical_notes_midi_can_have_accident (gushort midi);
GtkMusicMusicalNotes* gtk_music_musical_notes_new (void);
GtkMusicMusicalNotes* gtk_music_musical_notes_construct (GType object_type);
static void gtk_music_musical_notes_finalize (GtkMusicMusicalNotes* obj);

const gchar* GTK_MUSIC_MUSICAL_NOTES_note_names[12] = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};

GQuark gtk_music_musical_note_error_quark (void) {
	return g_quark_from_static_string ("gtk_music_musical_note_error-quark");
}


/**
     * All standard diatonic intervals, in order.
     **/
GType gtk_music_musical_notes_diatonic_intervals_get_type (void) {
	static volatile gsize gtk_music_musical_notes_diatonic_intervals_type_id__volatile = 0;
	if (g_once_init_enter (&gtk_music_musical_notes_diatonic_intervals_type_id__volatile)) {
		static const GEnumValue values[] = {{GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_UNISON, "GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_UNISON", "unison"}, {GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MINOR_SECOND, "GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MINOR_SECOND", "minor-second"}, {GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MAJOR_SECOND, "GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MAJOR_SECOND", "major-second"}, {GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MINOR_THIRD, "GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MINOR_THIRD", "minor-third"}, {GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MAJOR_THIRD, "GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MAJOR_THIRD", "major-third"}, {GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_PERFECT_FOURTH, "GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_PERFECT_FOURTH", "perfect-fourth"}, {GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_DIMINISHED_FIFTH, "GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_DIMINISHED_FIFTH", "diminished-fifth"}, {GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_PERFECT_FIFTH, "GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_PERFECT_FIFTH", "perfect-fifth"}, {GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MINOR_SIXTH, "GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MINOR_SIXTH", "minor-sixth"}, {GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MAJOR_SIXTH, "GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MAJOR_SIXTH", "major-sixth"}, {GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MINOR_SEVENTH, "GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MINOR_SEVENTH", "minor-seventh"}, {GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MAJOR_SEVENTH, "GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_MAJOR_SEVENTH", "major-seventh"}, {GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_PERFECT_OCTAVE, "GTK_MUSIC_MUSICAL_NOTES_DIATONIC_INTERVALS_PERFECT_OCTAVE", "perfect-octave"}, {0, NULL, NULL}};
		GType gtk_music_musical_notes_diatonic_intervals_type_id;
		gtk_music_musical_notes_diatonic_intervals_type_id = g_enum_register_static ("GtkMusicMusicalNotesDiatonicIntervals", values);
		g_once_init_leave (&gtk_music_musical_notes_diatonic_intervals_type_id__volatile, gtk_music_musical_notes_diatonic_intervals_type_id);
	}
	return gtk_music_musical_notes_diatonic_intervals_type_id__volatile;
}


/**
    * Checks whether a note is valid
    * @param note The note in scientific notation (as in E3)
    * @return True if the note is valid or false otherwise
    **/
gboolean gtk_music_musical_notes_validate (const gchar* note) {
	gboolean result = FALSE;
	GError * _inner_error_ = NULL;
	g_return_val_if_fail (note != NULL, FALSE);
	{
		const gchar* _tmp0_;
		_tmp0_ = note;
		gtk_music_musical_notes_get_note_as_midi_code (_tmp0_, &_inner_error_);
		if (_inner_error_ != NULL) {
			if (_inner_error_->domain == GTK_MUSIC_MUSICAL_NOTE_ERROR) {
				goto __catch0_gtk_music_musical_note_error;
			}
			g_critical ("file %s: line %d: unexpected error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
			g_clear_error (&_inner_error_);
			return FALSE;
		}
		result = TRUE;
		return result;
	}
	goto __finally0;
	__catch0_gtk_music_musical_note_error:
	{
		GError* e = NULL;
		e = _inner_error_;
		_inner_error_ = NULL;
		result = FALSE;
		_g_error_free0 (e);
		return result;
	}
	__finally0:
	g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
	g_clear_error (&_inner_error_);
	return FALSE;
}


/**
    * Checks whether a string represents a note without octave
    * @param needle The string to be checked
    * @return True if it's a note without octave or false otherwise
    **/
gboolean gtk_music_musical_notes_is_incomplete (const gchar* needle) {
	gboolean result = FALSE;
	g_return_val_if_fail (needle != NULL, FALSE);
	{
		gint i;
		i = 0;
		{
			gboolean _tmp0_;
			_tmp0_ = TRUE;
			while (TRUE) {
				gboolean _tmp1_;
				gint _tmp3_;
				gint _tmp4_;
				const gchar* _tmp5_;
				const gchar* _tmp6_;
				_tmp1_ = _tmp0_;
				if (!_tmp1_) {
					gint _tmp2_;
					_tmp2_ = i;
					i = _tmp2_ + 1;
				}
				_tmp0_ = FALSE;
				_tmp3_ = i;
				if (!(_tmp3_ < G_N_ELEMENTS (GTK_MUSIC_MUSICAL_NOTES_note_names))) {
					break;
				}
				_tmp4_ = i;
				_tmp5_ = GTK_MUSIC_MUSICAL_NOTES_note_names[_tmp4_];
				_tmp6_ = needle;
				if (g_strcmp0 (_tmp5_, _tmp6_) == 0) {
					result = TRUE;
					return result;
				}
			}
		}
	}
	result = FALSE;
	return result;
}


/**
     * Returns all notes with a given name (map C to => C0, C1, C2, ...);
     * @param incompleteNote A note without its octave component
     * @return A set of all possible notes with this name
     **/
GeeHashSet* gtk_music_musical_notes_make (const gchar* incompleteNote, GError** error) {
	GeeHashSet* result = NULL;
	const gchar* _tmp0_;
	gboolean _tmp1_ = FALSE;
	gushort start;
	gushort end;
	const gchar* _tmp3_;
	GeeHashSet* _tmp11_;
	GeeHashSet* notes;
	GError * _inner_error_ = NULL;
	g_return_val_if_fail (incompleteNote != NULL, NULL);
	_tmp0_ = incompleteNote;
	_tmp1_ = gtk_music_musical_notes_is_incomplete (_tmp0_);
	if (!_tmp1_) {
		GError* _tmp2_;
		_tmp2_ = g_error_new_literal (GTK_MUSIC_MUSICAL_NOTE_ERROR, GTK_MUSIC_MUSICAL_NOTE_ERROR_ALREADY_COMPLETE, "Note is complete!");
		_inner_error_ = _tmp2_;
		if (_inner_error_->domain == GTK_MUSIC_MUSICAL_NOTE_ERROR) {
			g_propagate_error (error, _inner_error_);
			return NULL;
		} else {
			g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
			g_clear_error (&_inner_error_);
			return NULL;
		}
	}
	start = (gushort) 1;
	end = (gushort) 7;
	_tmp3_ = incompleteNote;
	if (g_strcmp0 (_tmp3_, "C") == 0) {
		end = (gushort) 8;
	} else {
		gboolean _tmp4_ = FALSE;
		gboolean _tmp5_ = FALSE;
		const gchar* _tmp6_;
		gboolean _tmp8_;
		gboolean _tmp10_;
		_tmp6_ = incompleteNote;
		if (g_strcmp0 (_tmp6_, "A") == 0) {
			_tmp5_ = TRUE;
		} else {
			const gchar* _tmp7_;
			_tmp7_ = incompleteNote;
			_tmp5_ = g_strcmp0 (_tmp7_, "A#") == 0;
		}
		_tmp8_ = _tmp5_;
		if (_tmp8_) {
			_tmp4_ = TRUE;
		} else {
			const gchar* _tmp9_;
			_tmp9_ = incompleteNote;
			_tmp4_ = g_strcmp0 (_tmp9_, "B") == 0;
		}
		_tmp10_ = _tmp4_;
		if (_tmp10_) {
			start = (gushort) 0;
		}
	}
	_tmp11_ = gee_hash_set_new (G_TYPE_STRING, (GBoxedCopyFunc) g_strdup, g_free, NULL, NULL, NULL, NULL, NULL, NULL);
	notes = _tmp11_;
	{
		gushort _tmp12_;
		gushort i;
		_tmp12_ = start;
		i = _tmp12_;
		{
			gboolean _tmp13_;
			_tmp13_ = TRUE;
			while (TRUE) {
				gboolean _tmp14_;
				gushort _tmp16_;
				gushort _tmp17_;
				GeeHashSet* _tmp18_;
				const gchar* _tmp19_;
				gushort _tmp20_;
				gchar* _tmp21_ = NULL;
				gchar* _tmp22_;
				gchar* _tmp23_;
				gchar* _tmp24_;
				_tmp14_ = _tmp13_;
				if (!_tmp14_) {
					gushort _tmp15_;
					_tmp15_ = i;
					i = _tmp15_ + 1;
				}
				_tmp13_ = FALSE;
				_tmp16_ = i;
				_tmp17_ = end;
				if (!(_tmp16_ <= _tmp17_)) {
					break;
				}
				_tmp18_ = notes;
				_tmp19_ = incompleteNote;
				_tmp20_ = i;
				_tmp21_ = g_strdup_printf ("%hu", _tmp20_);
				_tmp22_ = _tmp21_;
				_tmp23_ = g_strconcat (_tmp19_, _tmp22_, NULL);
				_tmp24_ = _tmp23_;
				gee_abstract_collection_add ((GeeAbstractCollection*) _tmp18_, _tmp24_);
				_g_free0 (_tmp24_);
				_g_free0 (_tmp22_);
			}
		}
	}
	result = notes;
	return result;
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
static gchar string_get (const gchar* self, glong index) {
	gchar result = '\0';
	glong _tmp0_;
	gchar _tmp1_;
	g_return_val_if_fail (self != NULL, '\0');
	_tmp0_ = index;
	_tmp1_ = ((gchar*) self)[_tmp0_];
	result = _tmp1_;
	return result;
}


static gchar* string_slice (const gchar* self, glong start, glong end) {
	gchar* result = NULL;
	gint _tmp0_;
	gint _tmp1_;
	glong string_length;
	glong _tmp2_;
	glong _tmp5_;
	gboolean _tmp8_ = FALSE;
	glong _tmp9_;
	gboolean _tmp12_;
	gboolean _tmp13_ = FALSE;
	glong _tmp14_;
	gboolean _tmp17_;
	glong _tmp18_;
	glong _tmp19_;
	glong _tmp20_;
	glong _tmp21_;
	glong _tmp22_;
	gchar* _tmp23_ = NULL;
	g_return_val_if_fail (self != NULL, NULL);
	_tmp0_ = strlen (self);
	_tmp1_ = _tmp0_;
	string_length = (glong) _tmp1_;
	_tmp2_ = start;
	if (_tmp2_ < ((glong) 0)) {
		glong _tmp3_;
		glong _tmp4_;
		_tmp3_ = string_length;
		_tmp4_ = start;
		start = _tmp3_ + _tmp4_;
	}
	_tmp5_ = end;
	if (_tmp5_ < ((glong) 0)) {
		glong _tmp6_;
		glong _tmp7_;
		_tmp6_ = string_length;
		_tmp7_ = end;
		end = _tmp6_ + _tmp7_;
	}
	_tmp9_ = start;
	if (_tmp9_ >= ((glong) 0)) {
		glong _tmp10_;
		glong _tmp11_;
		_tmp10_ = start;
		_tmp11_ = string_length;
		_tmp8_ = _tmp10_ <= _tmp11_;
	} else {
		_tmp8_ = FALSE;
	}
	_tmp12_ = _tmp8_;
	g_return_val_if_fail (_tmp12_, NULL);
	_tmp14_ = end;
	if (_tmp14_ >= ((glong) 0)) {
		glong _tmp15_;
		glong _tmp16_;
		_tmp15_ = end;
		_tmp16_ = string_length;
		_tmp13_ = _tmp15_ <= _tmp16_;
	} else {
		_tmp13_ = FALSE;
	}
	_tmp17_ = _tmp13_;
	g_return_val_if_fail (_tmp17_, NULL);
	_tmp18_ = start;
	_tmp19_ = end;
	g_return_val_if_fail (_tmp18_ <= _tmp19_, NULL);
	_tmp20_ = start;
	_tmp21_ = end;
	_tmp22_ = start;
	_tmp23_ = g_strndup (((gchar*) self) + _tmp20_, (gsize) (_tmp21_ - _tmp22_));
	result = _tmp23_;
	return result;
}


gushort gtk_music_musical_notes_get_note_as_midi_code (const gchar* note, GError** error) {
	gushort result = 0U;
	gshort high;
	gshort low;
	gchar octave = '\0';
	gchar* note_name = NULL;
	const gchar* _tmp0_;
	gint _tmp1_;
	gint _tmp2_;
	const gchar* _tmp4_;
	const gchar* _tmp5_;
	gint _tmp6_;
	gint _tmp7_;
	gchar _tmp8_ = '\0';
	gchar _tmp9_;
	gboolean _tmp10_ = FALSE;
	gchar _tmp12_;
	gint _tmp13_ = 0;
	const gchar* _tmp14_;
	const gchar* _tmp15_;
	gint _tmp16_;
	gint _tmp17_;
	gchar* _tmp18_ = NULL;
	gshort _tmp27_;
	gshort _tmp28_;
	gshort _tmp29_;
	gint midi_code;
	gboolean _tmp30_ = FALSE;
	gint _tmp31_;
	gboolean _tmp33_;
	GError * _inner_error_ = NULL;
	g_return_val_if_fail (note != NULL, 0U);
	high = (gshort) (-1);
	low = (gshort) (-1);
	_tmp0_ = note;
	_tmp1_ = strlen (_tmp0_);
	_tmp2_ = _tmp1_;
	if (_tmp2_ < 2) {
		GError* _tmp3_;
		_tmp3_ = g_error_new_literal (GTK_MUSIC_MUSICAL_NOTE_ERROR, GTK_MUSIC_MUSICAL_NOTE_ERROR_INVALID_NOTE, "Invalid note length!");
		_inner_error_ = _tmp3_;
		if (_inner_error_->domain == GTK_MUSIC_MUSICAL_NOTE_ERROR) {
			g_propagate_error (error, _inner_error_);
			_g_free0 (note_name);
			return 0U;
		} else {
			_g_free0 (note_name);
			g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
			g_clear_error (&_inner_error_);
			return 0U;
		}
	}
	_tmp4_ = note;
	_tmp5_ = note;
	_tmp6_ = strlen (_tmp5_);
	_tmp7_ = _tmp6_;
	_tmp8_ = string_get (_tmp4_, (glong) (_tmp7_ - 1));
	octave = _tmp8_;
	_tmp9_ = octave;
	_tmp10_ = g_ascii_isdigit (_tmp9_);
	if (!_tmp10_) {
		GError* _tmp11_;
		_tmp11_ = g_error_new_literal (GTK_MUSIC_MUSICAL_NOTE_ERROR, GTK_MUSIC_MUSICAL_NOTE_ERROR_INVALID_NOTE, "Invalid octave!");
		_inner_error_ = _tmp11_;
		if (_inner_error_->domain == GTK_MUSIC_MUSICAL_NOTE_ERROR) {
			g_propagate_error (error, _inner_error_);
			_g_free0 (note_name);
			return 0U;
		} else {
			_g_free0 (note_name);
			g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
			g_clear_error (&_inner_error_);
			return 0U;
		}
	}
	_tmp12_ = octave;
	_tmp13_ = g_ascii_digit_value (_tmp12_);
	high = (gshort) _tmp13_;
	_tmp14_ = note;
	_tmp15_ = note;
	_tmp16_ = strlen (_tmp15_);
	_tmp17_ = _tmp16_;
	_tmp18_ = string_slice (_tmp14_, (glong) 0, (glong) (_tmp17_ - 1));
	_g_free0 (note_name);
	note_name = _tmp18_;
	{
		gint i;
		i = 0;
		{
			gboolean _tmp19_;
			_tmp19_ = TRUE;
			while (TRUE) {
				gboolean _tmp20_;
				gint _tmp22_;
				gint _tmp23_;
				const gchar* _tmp24_;
				const gchar* _tmp25_;
				_tmp20_ = _tmp19_;
				if (!_tmp20_) {
					gint _tmp21_;
					_tmp21_ = i;
					i = _tmp21_ + 1;
				}
				_tmp19_ = FALSE;
				_tmp22_ = i;
				if (!(_tmp22_ < G_N_ELEMENTS (GTK_MUSIC_MUSICAL_NOTES_note_names))) {
					break;
				}
				_tmp23_ = i;
				_tmp24_ = GTK_MUSIC_MUSICAL_NOTES_note_names[_tmp23_];
				_tmp25_ = note_name;
				if (g_strcmp0 (_tmp24_, _tmp25_) == 0) {
					gint _tmp26_;
					_tmp26_ = i;
					low = (gshort) _tmp26_;
					break;
				}
			}
		}
	}
	_tmp27_ = low;
	if (((gint) _tmp27_) == (-1)) {
		result = (gushort) (-1);
		_g_free0 (note_name);
		return result;
	}
	_tmp28_ = high;
	_tmp29_ = low;
	midi_code = ((_tmp28_ * 12) + _tmp29_) + 12;
	_tmp31_ = midi_code;
	if (_tmp31_ > 108) {
		_tmp30_ = TRUE;
	} else {
		gint _tmp32_;
		_tmp32_ = midi_code;
		_tmp30_ = _tmp32_ < 21;
	}
	_tmp33_ = _tmp30_;
	if (_tmp33_) {
		GError* _tmp34_;
		_tmp34_ = g_error_new_literal (GTK_MUSIC_MUSICAL_NOTE_ERROR, GTK_MUSIC_MUSICAL_NOTE_ERROR_INVALID_NOTE, "Out of range (A0 --> C8)");
		_inner_error_ = _tmp34_;
		if (_inner_error_->domain == GTK_MUSIC_MUSICAL_NOTE_ERROR) {
			g_propagate_error (error, _inner_error_);
			_g_free0 (note_name);
			return 0U;
		} else {
			_g_free0 (note_name);
			g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
			g_clear_error (&_inner_error_);
			return 0U;
		}
	}
	result = (gushort) midi_code;
	_g_free0 (note_name);
	return result;
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
gchar* gtk_music_musical_notes_get_note_from_midi_code (gushort midi, GError** error) {
	gchar* result = NULL;
	gboolean _tmp0_ = FALSE;
	gushort _tmp1_;
	gboolean _tmp3_;
	gushort _tmp5_;
	gushort _tmp6_;
	gushort octave;
	gushort _tmp7_;
	gushort note_index;
	const gchar* _tmp8_;
	gchar* _tmp9_;
	gchar* note;
	const gchar* _tmp10_;
	gchar* _tmp11_ = NULL;
	gchar* _tmp12_;
	gchar* _tmp13_;
	GError * _inner_error_ = NULL;
	_tmp1_ = midi;
	if (((gint) _tmp1_) > 108) {
		_tmp0_ = TRUE;
	} else {
		gushort _tmp2_;
		_tmp2_ = midi;
		_tmp0_ = ((gint) _tmp2_) < 21;
	}
	_tmp3_ = _tmp0_;
	if (_tmp3_) {
		GError* _tmp4_;
		_tmp4_ = g_error_new_literal (GTK_MUSIC_MUSICAL_NOTE_ERROR, GTK_MUSIC_MUSICAL_NOTE_ERROR_INVALID_MIDI, "Not in range 21..108");
		_inner_error_ = _tmp4_;
		if (_inner_error_->domain == GTK_MUSIC_MUSICAL_NOTE_ERROR) {
			g_propagate_error (error, _inner_error_);
			return NULL;
		} else {
			g_critical ("file %s: line %d: uncaught error: %s (%s, %d)", __FILE__, __LINE__, _inner_error_->message, g_quark_to_string (_inner_error_->domain), _inner_error_->code);
			g_clear_error (&_inner_error_);
			return NULL;
		}
	}
	_tmp5_ = midi;
	midi = (gushort) (_tmp5_ - 12);
	_tmp6_ = midi;
	octave = (gushort) (_tmp6_ / 12);
	_tmp7_ = midi;
	note_index = (gushort) (_tmp7_ % 12);
	_tmp8_ = GTK_MUSIC_MUSICAL_NOTES_note_names[note_index];
	_tmp9_ = g_strdup (_tmp8_);
	note = _tmp9_;
	_tmp10_ = note;
	_tmp11_ = g_strdup_printf ("%hu", octave);
	_tmp12_ = _tmp11_;
	_tmp13_ = g_strconcat (_tmp10_, _tmp12_, NULL);
	_g_free0 (note);
	note = _tmp13_;
	_g_free0 (_tmp12_);
	result = note;
	return result;
}


/**
     * Checks whether a given MIDI code is an accidental note (C#, D#, ...)
     * @param midi The MIDI code of a note
     * @return Whether the note has an accidental
     **/
gboolean gtk_music_musical_notes_midi_is_accident (gushort midi) {
	gboolean result = FALSE;
	gushort _tmp0_;
	_tmp0_ = midi;
	switch (_tmp0_ % 12) {
		case 1:
		case 3:
		case 6:
		case 8:
		case 10:
		{
			result = TRUE;
			return result;
		}
		default:
		{
			result = FALSE;
			return result;
		}
	}
}


/**
     * Checks whether a given MIDI code is different of E or B
     * @param midi The MIDI code of a note
     * @return Whether the note can have an accident (thus, neither E nor B)
     **/
gboolean gtk_music_musical_notes_midi_can_have_accident (gushort midi) {
	gboolean result = FALSE;
	gushort _tmp0_;
	gushort norm_midi;
	gboolean _tmp1_ = FALSE;
	gushort _tmp2_;
	gboolean _tmp4_;
	_tmp0_ = midi;
	norm_midi = (gushort) (_tmp0_ % 12);
	_tmp2_ = norm_midi;
	if (((gint) _tmp2_) != 4) {
		gushort _tmp3_;
		_tmp3_ = norm_midi;
		_tmp1_ = ((gint) _tmp3_) != 11;
	} else {
		_tmp1_ = FALSE;
	}
	_tmp4_ = _tmp1_;
	result = _tmp4_;
	return result;
}


GtkMusicMusicalNotes* gtk_music_musical_notes_construct (GType object_type) {
	GtkMusicMusicalNotes* self = NULL;
	self = (GtkMusicMusicalNotes*) g_type_create_instance (object_type);
	return self;
}


GtkMusicMusicalNotes* gtk_music_musical_notes_new (void) {
	return gtk_music_musical_notes_construct (GTK_MUSIC_TYPE_MUSICAL_NOTES);
}


static void gtk_music_value_musical_notes_init (GValue* value) {
	value->data[0].v_pointer = NULL;
}


static void gtk_music_value_musical_notes_free_value (GValue* value) {
	if (value->data[0].v_pointer) {
		gtk_music_musical_notes_unref (value->data[0].v_pointer);
	}
}


static void gtk_music_value_musical_notes_copy_value (const GValue* src_value, GValue* dest_value) {
	if (src_value->data[0].v_pointer) {
		dest_value->data[0].v_pointer = gtk_music_musical_notes_ref (src_value->data[0].v_pointer);
	} else {
		dest_value->data[0].v_pointer = NULL;
	}
}


static gpointer gtk_music_value_musical_notes_peek_pointer (const GValue* value) {
	return value->data[0].v_pointer;
}


static gchar* gtk_music_value_musical_notes_collect_value (GValue* value, guint n_collect_values, GTypeCValue* collect_values, guint collect_flags) {
	if (collect_values[0].v_pointer) {
		GtkMusicMusicalNotes* object;
		object = collect_values[0].v_pointer;
		if (object->parent_instance.g_class == NULL) {
			return g_strconcat ("invalid unclassed object pointer for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
		} else if (!g_value_type_compatible (G_TYPE_FROM_INSTANCE (object), G_VALUE_TYPE (value))) {
			return g_strconcat ("invalid object type `", g_type_name (G_TYPE_FROM_INSTANCE (object)), "' for value type `", G_VALUE_TYPE_NAME (value), "'", NULL);
		}
		value->data[0].v_pointer = gtk_music_musical_notes_ref (object);
	} else {
		value->data[0].v_pointer = NULL;
	}
	return NULL;
}


static gchar* gtk_music_value_musical_notes_lcopy_value (const GValue* value, guint n_collect_values, GTypeCValue* collect_values, guint collect_flags) {
	GtkMusicMusicalNotes** object_p;
	object_p = collect_values[0].v_pointer;
	if (!object_p) {
		return g_strdup_printf ("value location for `%s' passed as NULL", G_VALUE_TYPE_NAME (value));
	}
	if (!value->data[0].v_pointer) {
		*object_p = NULL;
	} else if (collect_flags & G_VALUE_NOCOPY_CONTENTS) {
		*object_p = value->data[0].v_pointer;
	} else {
		*object_p = gtk_music_musical_notes_ref (value->data[0].v_pointer);
	}
	return NULL;
}


GParamSpec* gtk_music_param_spec_musical_notes (const gchar* name, const gchar* nick, const gchar* blurb, GType object_type, GParamFlags flags) {
	GtkMusicParamSpecMusicalNotes* spec;
	g_return_val_if_fail (g_type_is_a (object_type, GTK_MUSIC_TYPE_MUSICAL_NOTES), NULL);
	spec = g_param_spec_internal (G_TYPE_PARAM_OBJECT, name, nick, blurb, flags);
	G_PARAM_SPEC (spec)->value_type = object_type;
	return G_PARAM_SPEC (spec);
}


gpointer gtk_music_value_get_musical_notes (const GValue* value) {
	g_return_val_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, GTK_MUSIC_TYPE_MUSICAL_NOTES), NULL);
	return value->data[0].v_pointer;
}


void gtk_music_value_set_musical_notes (GValue* value, gpointer v_object) {
	GtkMusicMusicalNotes* old;
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, GTK_MUSIC_TYPE_MUSICAL_NOTES));
	old = value->data[0].v_pointer;
	if (v_object) {
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, GTK_MUSIC_TYPE_MUSICAL_NOTES));
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
		value->data[0].v_pointer = v_object;
		gtk_music_musical_notes_ref (value->data[0].v_pointer);
	} else {
		value->data[0].v_pointer = NULL;
	}
	if (old) {
		gtk_music_musical_notes_unref (old);
	}
}


void gtk_music_value_take_musical_notes (GValue* value, gpointer v_object) {
	GtkMusicMusicalNotes* old;
	g_return_if_fail (G_TYPE_CHECK_VALUE_TYPE (value, GTK_MUSIC_TYPE_MUSICAL_NOTES));
	old = value->data[0].v_pointer;
	if (v_object) {
		g_return_if_fail (G_TYPE_CHECK_INSTANCE_TYPE (v_object, GTK_MUSIC_TYPE_MUSICAL_NOTES));
		g_return_if_fail (g_value_type_compatible (G_TYPE_FROM_INSTANCE (v_object), G_VALUE_TYPE (value)));
		value->data[0].v_pointer = v_object;
	} else {
		value->data[0].v_pointer = NULL;
	}
	if (old) {
		gtk_music_musical_notes_unref (old);
	}
}


static void gtk_music_musical_notes_class_init (GtkMusicMusicalNotesClass * klass) {
	gtk_music_musical_notes_parent_class = g_type_class_peek_parent (klass);
	GTK_MUSIC_MUSICAL_NOTES_CLASS (klass)->finalize = gtk_music_musical_notes_finalize;
}


static void gtk_music_musical_notes_instance_init (GtkMusicMusicalNotes * self) {
	self->ref_count = 1;
}


static void gtk_music_musical_notes_finalize (GtkMusicMusicalNotes* obj) {
	GtkMusicMusicalNotes * self;
	self = G_TYPE_CHECK_INSTANCE_CAST (obj, GTK_MUSIC_TYPE_MUSICAL_NOTES, GtkMusicMusicalNotes);
}


GType gtk_music_musical_notes_get_type (void) {
	static volatile gsize gtk_music_musical_notes_type_id__volatile = 0;
	if (g_once_init_enter (&gtk_music_musical_notes_type_id__volatile)) {
		static const GTypeValueTable g_define_type_value_table = { gtk_music_value_musical_notes_init, gtk_music_value_musical_notes_free_value, gtk_music_value_musical_notes_copy_value, gtk_music_value_musical_notes_peek_pointer, "p", gtk_music_value_musical_notes_collect_value, "p", gtk_music_value_musical_notes_lcopy_value };
		static const GTypeInfo g_define_type_info = { sizeof (GtkMusicMusicalNotesClass), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) gtk_music_musical_notes_class_init, (GClassFinalizeFunc) NULL, NULL, sizeof (GtkMusicMusicalNotes), 0, (GInstanceInitFunc) gtk_music_musical_notes_instance_init, &g_define_type_value_table };
		static const GTypeFundamentalInfo g_define_type_fundamental_info = { (G_TYPE_FLAG_CLASSED | G_TYPE_FLAG_INSTANTIATABLE | G_TYPE_FLAG_DERIVABLE | G_TYPE_FLAG_DEEP_DERIVABLE) };
		GType gtk_music_musical_notes_type_id;
		gtk_music_musical_notes_type_id = g_type_register_fundamental (g_type_fundamental_next (), "GtkMusicMusicalNotes", &g_define_type_info, &g_define_type_fundamental_info, 0);
		g_once_init_leave (&gtk_music_musical_notes_type_id__volatile, gtk_music_musical_notes_type_id);
	}
	return gtk_music_musical_notes_type_id__volatile;
}


gpointer gtk_music_musical_notes_ref (gpointer instance) {
	GtkMusicMusicalNotes* self;
	self = instance;
	g_atomic_int_inc (&self->ref_count);
	return instance;
}


void gtk_music_musical_notes_unref (gpointer instance) {
	GtkMusicMusicalNotes* self;
	self = instance;
	if (g_atomic_int_dec_and_test (&self->ref_count)) {
		GTK_MUSIC_MUSICAL_NOTES_GET_CLASS (self)->finalize (self);
		g_type_free_instance ((GTypeInstance *) self);
	}
}



