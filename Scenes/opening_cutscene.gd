extends Control

func _ready() -> void:
	$AnimationPlayer.play("opening_cutscene")
	Game.update_ui.connect(update_ui)

func update_ui() -> void:
	$Paused.visible = get_tree().paused

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	Game.load_scene.emit(load("res://Scenes/level01.tscn"))
