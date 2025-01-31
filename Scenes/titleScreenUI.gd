extends Control

func _ready() -> void:
	$Play.grab_focus()

func _on_play_pressed() -> void:
	Game.load_scene.emit(load("res://Scenes/tutorial.tscn"))


func _on_credits_pressed() -> void:
	$CredText.visible = !$CredText.visible
