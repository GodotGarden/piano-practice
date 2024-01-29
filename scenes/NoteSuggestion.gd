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
	note_label.modulate = Color.WHITE
	note_label.text = current_note


func _ready():
	note_label = get_node("NoteLabel")
	MIDIHandler.connect("midi_note_on", self._on_midi_note_on)
	randomize()
	select_and_display_note()
	var delay_timer = $DelayTimer
	delay_timer.wait_time = 1.0  # Set the desired delay time
	delay_timer.one_shot = true
	delay_timer.autostart = false

func _on_midi_note_on(note_info: MIDIHandler.MIDINoteInfo):
	if note_info.pitch_class == current_note:
		emit_signal("note_correct")
		# Visual feedback for correct note
		note_label.modulate = Color.GREEN
		print("Correct note played!")
		$DelayTimer.start()
		await $DelayTimer.timeout
		select_and_display_note()
	else:
		emit_signal("note_incorrect")
		# Visual feedback for incorrect note
		note_label.modulate = Color.RED
		print("Incorrect note played!")
