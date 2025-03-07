extends Area3D

@export var start_burning := false

@onready var item_resource = load("res://Gadgets/boiler.tres")
var output_node: Node3D
var power_current := 5.0
const is_output := true

@export var tutorial_object: Node3D

func tutorial_tool():
	if is_instance_valid(tutorial_object) and tutorial_object:
		tutorial_object.queue_free()

func _ready() -> void:
	item_resource = item_resource.duplicate()
	if start_burning:
		$Smoke.emitting = true
		$sound.playing = true
		$MeshInstance3D.visible = true
		$OmniLight.active = true
		#item_resource.power = 9999
	$OmniLight.update_item()
		

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
		output_node = body
		$plugSound.play()
		output_node.freeze = true
		output_node.plugged_into = self
		output_node.is_reciever = true
		output_node.pass_power(power_current)
		output_node.global_position = $PlugPos.global_position
		output_node.global_rotation = $PlugPos.global_rotation
		output_node.update_connections()
		$ServeTimer.start()
	if body.item_resource.fuel:
		item_resource.power += body.item_resource.fuel
		tutorial_tool()
		$ServeTimer.start()
		$burnSound.play()
		body.queue_free()

func _on_serve_timer_timeout() -> void:
	if output_node and output_node.plugged_into:
		print(item_resource.power)
		if item_resource.power >= power_current:
			output_node.pass_power(power_current)
			$Smoke.emitting = true
			$sound.playing = true
			$MeshInstance3D.visible = true
			$OmniLight.active = true
		else:
			$ServeTimer.stop()
			$Smoke.emitting = false
			$sound.playing = false
			$MeshInstance3D.visible = false
			$OmniLight.active = false
		$OmniLight.update_item()
	else:
		$ServeTimer.stop()
		$Smoke.emitting = false
		$sound.playing = false
		$MeshInstance3D.visible = false
		$OmniLight.active = false
		$OmniLight.update_item()
		
