extends Area3D

var output_node: Node3D
var power := 100000.0
var power_current := 5.0
const is_output := true


func eject_object(object) -> void:
	object.position += Vector3(0, 0.5, 0)
	object.freeze = false
	object.linear_velocity = Game.player_last_direction * 5
	var dir = Game.player_last_direction.normalized()
	object.rotation.y = atan2(-dir.x, -dir.z)

func _on_body_entered(body: Node3D) -> void:
	if output_node and "plugged_into" in body:
		eject_object(output_node)
		body.plugged_into = null
		output_node.is_reciever = false
		output_node = null
	if body.item_resource.plug:
		print("hey?")
		output_node = body
		output_node.freeze = true
		output_node.plugged_into = self
		output_node.is_reciever = true
		output_node.pass_power(power_current)
		output_node.global_position = $PlugPos.global_position
		$ServeTimer.start()

func _on_serve_timer_timeout() -> void:
	if output_node.plugged_into:
		if power >= power_current:
			output_node.pass_power(power_current)
	else:
		output_node = null
		$ServeTimer.stop()
