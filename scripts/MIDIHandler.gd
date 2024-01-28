extends Node

# Signal declarations
signal midi_note_on(note, velocity)
signal midi_note_off(note, velocity)

# Constants for MIDI messages
const NOTE_ON_MESSAGE = 9
const NOTE_OFF_MESSAGE = 8

func _init():
	# Initialize MIDI input 
	# when the singleton is created
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())

func process_midi_input(input_event):
	if input_event is InputEventMIDI:
		_print_midi_info(input_event)
		var midi_message = input_event.message  # Extract the message type
		var midi_note = input_event.pitch  # MIDI note number
		var midi_velocity = input_event.velocity  # Velocity (used to determine note-on/off)
		
		if midi_message == NOTE_ON_MESSAGE and midi_velocity > 0:
			emit_signal("midi_note_on", midi_note, midi_velocity)
		elif midi_message == NOTE_OFF_MESSAGE or (midi_message == NOTE_ON_MESSAGE and midi_velocity == 0):
			emit_signal("midi_note_off", midi_note, midi_velocity)


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
