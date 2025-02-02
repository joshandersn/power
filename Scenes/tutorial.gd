extends Node3D

@export var objective: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.check_level_objective.connect(proceed_level)
	Game.play_music.emit(load("res://Sound/tutorial.mp3"))

func proceed_level() -> void:
	if objective and objective.charged:
		await get_tree().create_timer(3).timeout
		Game.load_scene.emit(load("res://Scenes/OpeningCutscene.tscn"))
	
func delete_this(object) -> void:
	object.queue_free()
