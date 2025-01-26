extends Node

signal load_scene
signal update_ui
signal push_prompt
signal dismiss_all_prompts
signal reparent_to_world

var input_method := "keyboard"
var player_last_direction: Vector3
