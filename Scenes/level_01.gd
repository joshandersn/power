extends Node3D

func _ready() -> void:
	Game.scan_level.emit()
	Game.check_level_objective.connect(proceed_level)

func proceed_level():
	if $SuperLight.active and $SuperLight2.active:
		Game.push_dialog.emit("That's it! Those goblins should leave us alone now.")
		await get_tree().create_timer(5).timeout
		Game.load_scene.emit(load("res://Scenes/EndingCutscene.tscn"))
