extends Node

const DEBUG = false

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
signal check_level_objective
signal push_hint
signal clear_hints
signal play_music
signal stop_music

var difficulty = 1
signal difficulty_update

var input_method := "keyboard"
signal input_method_update

var player_last_direction: Vector3
var current_level: PackedScene

# Session
var enemy_count: int
var defences: Array[Node3D]
var goblin_kills: int
