extends Node3D

var active: bool

func _ready() -> void:
	update_item()

func update_item() -> void:
	if active:
		$light.light_energy = 10
	else:
		$light.light_energy = 0
