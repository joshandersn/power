extends Node3D

func _ready() -> void:
	Game.scan_level.emit()
	Game.check_level_objective.connect(proceed_level)
	Game.play_music.emit(load("res://Sound/overworld.mp3"))

func proceed_level():
	if $SuperLight.active or $SuperLight2.active:
		Game.play_music.emit(load("res://Sound/overworld_beat.mp3"))
	
	if $SuperLight.active and $SuperLight2.active:
		Game.stop_music.emit()
		Game.push_dialog.emit("That's it! Those goblins should leave us alone now.")
		await get_tree().create_timer(5).timeout
		Game.load_scene.emit(load("res://Scenes/EndingCutscene.tscn"))
