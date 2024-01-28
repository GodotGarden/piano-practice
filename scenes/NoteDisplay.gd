# NoteDisplay.gd
extends Node

var active_notes = []  # Array to store active notes
var notes_label: Label

func _ready():
	notes_label = get_node("NotesLabel")
	
	# Connect MIDIHandler signals to this scene's methods
	MIDIHandler.connect("midi_note_on", self.on_midi_note_on)
	MIDIHandler.connect("midi_note_off", self.on_midi_note_off)

# Called when a MIDI note is played
func on_midi_note_on(note_info: MIDIHandler.MIDINoteInfo):
	if not note_info.pitch_class in active_notes:
		active_notes.append(note_info.pitch_class)
	update_display()

# Called when a MIDI note is released
func on_midi_note_off(note_info: MIDIHandler.MIDINoteInfo):
	if note_info.pitch_class in active_notes:
		active_notes.erase(note_info.pitch_class)
	update_display()

# Update the display label with active notes
func update_display():
	var notes_text =  ", ".join(active_notes)
	notes_label.text = notes_text
