extends Node3D

@export var look_at_object: Node3D

func _ready() -> void:
	Game.scan_level.emit()
	Game.check_level_objective.connect(proceed_level)
	Game.play_music.emit(load("res://Sound/overworld.mp3"))
	if look_at_object:
		await get_tree().create_timer(10).timeout
		Game.push_dialog.emit("Look GOBLINS took all the batteries! Try and find a safe way to get them")
		Game.look_at.emit(look_at_object, 4)

func proceed_level():
	if Game.goblin_kills >= 1 and $GoblinGate and is_instance_valid($GoblinGate):
		$GoblinGate.queue_free()
		
	if $SuperLight.active or $SuperLight2.active:
		Game.play_music.emit(load("res://Sound/overworld_beat.mp3"))
	
	if $SuperLight.active and $SuperLight2.active:
		Game.stop_music.emit()
		Game.push_dialog.emit("That's it! Those goblins should leave us alone now.")
		await get_tree().create_timer(5).timeout
		Game.load_scene.emit(load("res://Scenes/EndingCutscene.tscn"))
