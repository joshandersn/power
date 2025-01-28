extends Node3D

var scene_to_load: PackedScene

func quick_load(scene: PackedScene):
	for i in $Scene.get_children():
		i.queue_free()
	var new_scene = scene.instantiate()
	$Scene.add_child(new_scene)
	Game.current_level = scene
	$Canvas/UI/LoseAnim.play("RESET")

func load_scene(scene: PackedScene):
	$Canvas/UI/FadeAnim.play("FadeIn")
	scene_to_load = scene

func finish_load() -> void:
	quick_load(scene_to_load)
	$Canvas/UI/FadeAnim.play("FadeOut")
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused

func scan_level() -> void:
	var e_count: int
	for i in get_children():
		# gat enemy count
		if i.is_in_group("Enemy"):
			e_count += 1
		if i.is_in_group("Defence"):
			Game.defences.append(i)
			
	Game.enemy_count = e_count


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.load_scene.connect(load_scene)
	Game.restart_level.connect(restart_level)
	if Game.DEBUG:
		quick_load(load("res://Scenes/level01.tscn"))
	else:
		load_scene(load("res://Scenes/titleScreen.tscn"))

func restart_level() -> void:
	load_scene(Game.current_level)


func _on_fade_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "FadeIn":
		finish_load()
