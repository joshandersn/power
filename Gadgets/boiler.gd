extends Area3D

var output: Node3D
var power := 100.0
var power_current := 5.0


func eject_object(object) -> void:
	object.position += Vector3(0, 0.5, 0)
	object.freeze = false
	object.linear_velocity = Game.player_last_direction * 5
	var dir = Game.player_last_direction.normalized()
	object.rotation.y = atan2(-dir.x, -dir.z)

func _on_body_entered(body: Node3D) -> void:
	if output:
		eject_object(output)
		output = null
	if body.item_resource.plug:
		output = body
		body.freeze = true
		body.plugged_into = self
		body.global_position = $PlugPos.global_position
		$ServeTimer.start()

func _on_serve_timer_timeout() -> void:
	if power >= power_current:
		output.item_resource.power =+ power_current
		power -= power_current
		print("sending ", power_current, " to ", output)
