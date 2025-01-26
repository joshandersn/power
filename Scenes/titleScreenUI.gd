extends Control

func _ready() -> void:
	$Play.grab_focus()

func _on_play_pressed() -> void:
	Game.load_scene.emit(load("res://Scenes/level01.tscn"))
