extends Node3D

@export var look_at_object: Node3D

func _ready() -> void:
	Game.scan_level.emit()
	Game.check_level_objective.connect(proceed_level)
	Game.play_music.emit(load("res://Sound/overworld.mp3"))
	
	await get_tree().create_timer(5).timeout
	Game.push_dialog.emit("Honey you've got to power up both BIG LIGHTS!")
	#Game.push_hint.emit(load("res://Assets/lights.png"), "Power both lights to win the level")
	Game.look_at.emit($SocketArray, 3)
	await get_tree().create_timer(3).timeout
	Game.look_at.emit($SocketArray2, 3)
	
	
	
	if look_at_object:
		await get_tree().create_timer(10).timeout
		Game.push_dialog.emit("Look GOBLINS took all the batteries! Try and find a safe way to get them")
		Game.look_at.emit(look_at_object, 4)

@onready var goblin_gate = $GoblinGate

var new_music_playing = false
func proceed_level():
	if Game.goblin_kills >= 1:
		goblin_gate.set_collision_layer_value(5, false)
		
	if $SuperLight.active or $SuperLight2.active and !new_music_playing:
		new_music_playing = true
		Game.play_music.emit(load("res://Sound/overworld_beat.mp3"))
	
	if $SuperLight.active and $SuperLight2.active:
		Game.stop_music.emit()
		Game.push_dialog.emit("That's it! Those goblins should leave us alone now.")
		await get_tree().create_timer(5).timeout
		Game.load_scene.emit(load("res://Scenes/EndingCutscene.tscn"))


func _on_gate_timer_timeout() -> void:
	goblin_gate.set_collision_layer_value(5, false)
