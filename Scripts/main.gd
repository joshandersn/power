extends Node3D

func load_scene(scene: PackedScene):
	for i in $Scene.get_children():
		i.queue_free()
	var new_scene = scene.instantiate()
	$Scene.add_child(new_scene)
	Game.current_level = scene
	$Canvas/UI/LoseAnim.play("RESET")
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.load_scene.connect(load_scene)
	Game.restart_level.connect(restart_level)
	load_scene(load("res://Scenes/titleScreen.tscn"))

func restart_level() -> void:
	load_scene(Game.current_level)
