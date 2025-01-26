extends Node3D

@export var target: Node3D
@export var follow_speed := 10.0

func _physics_process(delta: float) -> void:
	if target and is_instance_valid(target):
		global_position = lerp(global_position, target.global_position, delta * follow_speed)
