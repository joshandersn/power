extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()
	Game.stop_music.emit()
	$AnimationPlayer.play("Slideshow")
	Game.update_ui.connect(update_ui)

func update_ui() -> void:
	$Paused.visible = get_tree().paused

func _on_timer_timeout() -> void:
	pass

func push_slide(image):
	pass

func _on_button_pressed() -> void:
	Game.load_scene.emit(load("res://Scenes/titleScreen.tscn"))
