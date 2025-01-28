extends Node3D

var active: bool
@onready var green := load("res://Materials/green.tres")
@onready var red := load("res://Materials/red.tres")

func _ready() -> void:
	update_item()

func update_item() -> void:
	if active:
		$mesh.mesh.material = green
		$light.light_color = Color(0, 1, 0)
	else:
		$mesh.mesh.material = red
		$light.light_color = Color(1, 0, 0)
