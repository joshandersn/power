extends Node

signal load_scene
signal update_ui
signal push_prompt
signal dismiss_all_prompts

var input_method := "keyboard"
var player_last_direction: Vector3
