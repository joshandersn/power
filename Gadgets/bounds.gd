extends Area3D

@export var respawn: Node3D

func _on_body_entered(body: Node3D) -> void:
	if respawn:
		body.global_position = respawn.global_position
