extends Control

func _ready() -> void:
	$AnimationPlayer.play("opening_cutscene")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Game.load_scene.emit(load("res://Scenes/level01.tscn"))
