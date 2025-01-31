extends StaticBody3D

var can_spawn := true
var count := 0
@export var limit := 10

func _on_area_3d_body_entered(body: Node3D) -> void:
	if "item_resource" in body and body.item_resource.heavy and can_spawn and count <= limit:
		var new_branch = load("res://Items/Stick.tscn").instantiate()
		if (randi() % 2):
			new_branch.global_position = $A.global_position
			new_branch.linear_velocity = Vector3(1, 0, 2)
		else:
			new_branch.global_position = $B.global_position
			new_branch.linear_velocity = Vector3(2, 0, 1)
		add_sibling(new_branch)
		can_spawn = false
		$Timer.start()
		count += 1


func _on_timer_timeout() -> void:
	can_spawn = true
