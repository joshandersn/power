extends Node

const DEBUG = true

signal load_scene
signal update_ui
signal push_prompt
signal dismiss_all_prompts
signal push_dialog
signal lose
signal restart_level
signal scan_level
signal look_at
signal push_special_dialog

var input_method := "gamepad"
var player_last_direction: Vector3
var current_level: PackedScene

# Session
var enemy_count: int
var defences: Array[Node3D]
