extends Node2D

var piano_keys = []
# The ratio of the key height to screen height
var key_height_ratio = 0.25
var key_colors = {
	"white": Color(1, 1, 1),  # RGB color for white
	"black": Color(0, 0, 0)   # RGB color for black
}


# Called when the node enters the scene tree for the first time.
func _ready():
	piano_keys = _generate_piano_keys("C", 3, 3)  # Example usage
	_render_piano_keyboard()

	# Debug print to verify
	for key in piano_keys:
		print(key)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _generate_piano_keys(start_key: String, start_octave: int, num_octaves: int) -> Array:
	var keys_generated = []
	var notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
	var start_index = notes.find(start_key)
	if start_index == -1:
		print("Invalid start key")
		return keys_generated

	var midi_note = 12 * (start_octave + 1) + start_index  # MIDI note calculation

	for octave in range(start_octave, start_octave + num_octaves):
		for i in range(start_index, 12):  # Loop through notes starting from start_key
			var note = notes[i] + str(octave)
			var key_color = "black" if "#" in notes[i] else "white"
			keys_generated.append({"note_name": note, "midi_number": midi_note, "key_color": key_color})
			midi_note += 1

		start_index = 0  # Reset start index for next octaves

	return keys_generated

func _render_piano_keyboard():
	var screen_rect = get_viewport_rect()
	var num_keys = piano_keys.size()
	var gap = 2  # Width of the gap in pixels
	var total_gap_width = gap * (num_keys - 1)
	var key_width = (screen_rect.size.x - total_gap_width) / num_keys
	var key_height = screen_rect.size.y * key_height_ratio
	var key_size = Vector2(key_width, key_height)

	for i in range(num_keys):
		var key = piano_keys[i]
		var key_node = ColorRect.new()
		add_child(key_node)
		
		key_node.set_size(key_size)
		key_node.color = key_colors[key["key_color"]]
		var key_x_position = i * (key_width + gap)
		key_node.position = Vector2(key_x_position, screen_rect.size.y - key_height)

