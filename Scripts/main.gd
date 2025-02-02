extends Node3D

var scene_to_load: PackedScene

func quick_load(scene: PackedScene):
	for i in $Scene.get_children():
		i.queue_free()
	var new_scene = scene.instantiate()
	$Scene.add_child(new_scene)
	Game.current_level = scene
	$UI/LoseAnim.play("RESET")

func load_scene(scene: PackedScene):
	$UI/FadeAnim.play("FadeIn")
	scene_to_load = scene

func finish_load() -> void:
	quick_load(scene_to_load)
	$UI/FadeAnim.play("FadeOut")
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if Game.current_level != load("res://Scenes/titleScreen.tscn"):
			get_tree().paused = !get_tree().paused
			$UI/Pause.visible = get_tree().paused
			$UI/Pause/Resume.grab_focus()
			Game.update_ui.emit()

	if Input.is_action_just_pressed("debug"):
		load_scene(load("res://Scenes/EndingCutscene.tscn"))
		#play_music(load("res://Sound/overworld_beat.mp3"))

func stop_music() -> void:
	$Music.stop()

func play_music(music) -> void:
	$Music.stream = music
	$Music.play()

func scan_level() -> void:
	var e_count := 0
	Game.defences.resize(0)
	if $Scene.get_child(0):
		for i in $Scene.get_child(0).get_children():
			if i.is_in_group("Enemy"):
				e_count += 1
			if i.is_in_group("Defence"):
				Game.defences.append(i)
		Game.enemy_count = e_count
	else:
		push_error("No level detected")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.load_scene.connect(load_scene)
	Game.restart_level.connect(restart_level)
	Game.scan_level.connect(scan_level)
	Game.play_music.connect(play_music)
	Game.stop_music.connect(stop_music)
	if Game.DEBUG:
		quick_load(load("res://Scenes/level01.tscn"))
		#quick_load(load("res://Scenes/tutorial.tscn"))
	else:
		quick_load(load("res://Scenes/titleScreen.tscn"))

func restart_level() -> void:
	load_scene(Game.current_level)


func _on_fade_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "FadeIn":
		finish_load()
