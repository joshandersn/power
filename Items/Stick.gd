extends RigidBody3D

@onready var item_resource := load("res://Items/Stick.tres")


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy") and linear_velocity.length() > 0.1:
		body.take_damage()
		linear_velocity += Vector3.UP * 5
		angular_velocity += Vector3.UP * 10
