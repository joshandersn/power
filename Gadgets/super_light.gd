extends Node3D

@export var active: bool
@export var light_power := 10

func _ready() -> void:
	update_item()
	$Area3D.monitoring = false

func update_item() -> void:
	if active:
		$Area3D.monitoring = true
		$light.light_energy = light_power
	else:
		$light.light_energy = 0


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		body.incenerate()
