extends Node3D

func _ready() -> void:
	Game.scan_level.emit()
