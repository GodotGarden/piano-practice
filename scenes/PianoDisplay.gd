extends Node2D

var piano_keys = []
var keys_generated = []
# The ratio of the key height to screen height
var key_height_ratio = 0.25
var key_colors = {
	"white": Color(1, 1, 1),  # RGB color for white
	"black": Color(0, 0, 0),   # RGB color for black
	"pressed": Color(1, 0, 0),   # RGB color for red
}
var key_nodes = {}  # Dictionary to hold references to key nodes
var NOTE_ON_MESSAGE = 9
var NOTE_OFF_MESSAGE = 8
var OCTAVE_SEMITONES = 12

# Called when the node enters the scene tree for the first time.
func _ready():
	_generate_piano_keys("C", 2, 4)
	_render_piano_keyboard()

	# Initialize MIDI input
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())

func _input(input_event):
	if input_event is InputEventMIDI:
		var midi_message = input_event.message  # Extract the message type
		var midi_note = input_event.pitch  # MIDI note number
		var midi_velocity = input_event.velocity  # Velocity (used to determine note-on/off)
		
		if midi_message == NOTE_ON_MESSAGE and midi_velocity > 0:  # Note-on with velocity > 0
			_handle_midi_note_on(midi_note)
		elif midi_message == NOTE_OFF_MESSAGE and midi_velocity > 0:  # Note-off or note-on with 0 velocity
			_handle_midi_note_off(midi_note)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _generate_piano_keys(start_key: String, start_octave: int, num_octaves: int):
	var notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
	var start_index = notes.find(start_key)
	if start_index == -1:
		print("Invalid start key")

	var midi_note = OCTAVE_SEMITONES * (start_octave + 1) + start_index  # MIDI note calculation

	for octave in range(start_octave, start_octave + num_octaves):
		for i in range(start_index, OCTAVE_SEMITONES):  # Loop through notes starting from start_key
			var note = notes[i] + str(octave)
			var key_color = "black" if "#" in notes[i] else "white"
			keys_generated.append({"note_name": note, "midi_number": midi_note, "key_color": key_color})
			midi_note += 1

		start_index = 0  # Reset start index for next octaves

func _render_piano_keyboard():
	var screen_rect = get_viewport_rect()
	var num_keys = keys_generated.size()
	var gap = 2  # Width of the gap in pixels
	var total_gap_width = gap * (num_keys - 1)
	var key_width = (screen_rect.size.x - total_gap_width) / num_keys
	var key_height = screen_rect.size.y * key_height_ratio
	var key_size = Vector2(key_width, key_height)

	for i in range(num_keys):
		var key = keys_generated[i]
		var key_node = ColorRect.new()
		add_child(key_node)
		
		key_node.set_size(key_size)
		key_node.color = key_colors[key["key_color"]]
		var key_x_position = i * (key_width + gap)
		key_node.position = Vector2(key_x_position, screen_rect.size.y - key_height)
		
		# Store the reference to the key node
		key_nodes[key["note_name"]] = key_node

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

func midi_note_to_key_name(midi_note_number: int) -> String:
	var note_names = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
	var octave = (midi_note_number / OCTAVE_SEMITONES) - 1  # Calculate the octave
	var note_index = midi_note_number % OCTAVE_SEMITONES  # Get the note index within the octave
	var note_name = note_names[note_index] + str(octave)
	
	return note_name

func _handle_midi_note_on(midi_note):
	var key_name = midi_note_to_key_name(midi_note)

	if key_name in key_nodes:
		var key_node = key_nodes[key_name]

		# Change key appearance
		key_node.color = key_colors["pressed"]

func _handle_midi_note_off(midi_note):
	var key_name = midi_note_to_key_name(midi_note)
	if key_name in key_nodes:
		var key_node = key_nodes[key_name]
		
		# Find the original color for the key
		var original_color = "white"  # Default to white
		for key in keys_generated:
			if key["note_name"] == key_name:
				original_color = key["key_color"]
				break

		key_node.color = key_colors[original_color]  # Revert to original color
