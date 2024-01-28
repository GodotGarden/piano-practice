extends Node2D


func _input(event):
	MIDIHandler.process_midi_input(event)
