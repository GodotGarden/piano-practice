extends Node2D

# Signal declarations
signal note_correct
signal note_incorrect

# MIDI Note Names (without octaves)
const NOTE_NAMES = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
var note_label: Label
var current_note = ""


func select_and_display_note():
	var random_index = randi() % NOTE_NAMES.size()
	current_note = NOTE_NAMES[random_index]
	# Assuming you have a Label node in your scene to display the note
	note_label.text = current_note


func _ready():
	note_label = get_node("NoteLabel")
	MIDIHandler.connect("midi_note_on", self._on_midi_note_on)
	randomize()
	select_and_display_note()

func _on_midi_note_on(note_info: MIDIHandler.MIDINoteInfo):
	if note_info.pitch_class == current_note:
		emit_signal("note_correct")
		print("Correct note played!")
	else:
		emit_signal("note_incorrect")
		print("Incorrect note played!")
	# Optionally, select and display a new note
	select_and_display_note()
