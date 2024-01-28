extends Node

class MIDINoteInfo:
	var pitch_class: String
	var octave: int
	var velocity: int
	var midi_number: int

	func _init(
		_pitch_class: String,
		_octave: int,
		_velocity: int,
		_midi_number: int,
	):
		pitch_class = _pitch_class
		octave = _octave
		velocity = _velocity
		midi_number = _midi_number

# Signal declarations
signal midi_note_on(note_info: MIDINoteInfo)
signal midi_note_off(note_info: MIDINoteInfo)

# Constants for MIDI messages
const NOTE_ON_MESSAGE = 9
const NOTE_OFF_MESSAGE = 8

# MIDI Note to Note Name Mapping
var NOTE_NAMES = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]


func _init():
	# Initialize MIDI input 
	# when the singleton is created
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())

func process_midi_input(input_event):
	if input_event is InputEventMIDI:
		var midi_message = input_event.message
		var midi_note_number = input_event.pitch
		var midi_velocity = input_event.velocity

		var note_info = get_note_info(midi_note_number, midi_velocity)

		if midi_message == NOTE_ON_MESSAGE and midi_velocity > 0:
			emit_signal("midi_note_on", note_info)
		elif midi_message == NOTE_OFF_MESSAGE or (midi_message == NOTE_ON_MESSAGE and midi_velocity == 0):
			emit_signal("midi_note_off", note_info)

func get_note_info(midi_number, velocity) -> MIDINoteInfo:
	var octave = midi_number / 12 - 1
	var pitch_class = NOTE_NAMES[midi_number % 12]
	return MIDINoteInfo.new(
		pitch_class, 
		octave, 
		velocity, 
		midi_number
	)


func _print_midi_info(midi_event: InputEventMIDI):
	print(midi_event)
	print("Channel " + str(midi_event.channel))
	print("Message " + str(midi_event.message))
	print("Pitch " + str(midi_event.pitch))
	print("Velocity " + str(midi_event.velocity))
	print("Instrument " + str(midi_event.instrument))
	print("Pressure " + str(midi_event.pressure))
	print("Controller number: " + str(midi_event.controller_number))
	print("Controller value: " + str(midi_event.controller_value))
