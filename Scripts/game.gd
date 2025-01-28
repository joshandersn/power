extends Node

signal load_scene
signal update_ui
signal push_prompt
signal dismiss_all_prompts
signal reparent_to_world
signal push_dialog
signal lose
signal restart_level

var input_method := "keyboard"
var player_last_direction: Vector3
var current_level: PackedScene

# Session
var enemy_count: int
