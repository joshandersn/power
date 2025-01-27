extends Node3D

func load_scene(scene: PackedScene):
	for i in $Scene.get_children():
		i.queue_free()
	var new_scene = scene.instantiate()
	$Scene.add_child(new_scene)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.load_scene.connect(load_scene)
	
	load_scene(load("res://Scenes/titleScreen.tscn"))
