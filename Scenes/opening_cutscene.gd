extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()


func _on_timer_timeout() -> void:
	Game.load_scene.emit(load("res://Scenes/level01.tscn"))
