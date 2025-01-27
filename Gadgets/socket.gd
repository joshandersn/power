extends Area3D

@onready var item_resource := load("res://Gadgets/socket.tres")
@export var inserted_item: Node3D
var can_insert := true
var output_node: Node3D
var is_output: bool


func eject_object(object) -> void:
	inserted_item = null
	if object.item_resource.plug:
		object.position += Vector3(0, 0.5, 0)
	object.freeze = false
	object.global_position = $InsertPos.global_position
	object.linear_velocity = Game.player_last_direction * 5
	var dir = Game.player_last_direction.normalized()
	object.rotation.y = atan2(-dir.x, -dir.z)

func receive_power(amt):
	if inserted_item:
		inserted_item.receive_power(amt)
		inserted_item.update_item()

func insert_item(object: Node3D) -> void:
	if object.item_resource.plug:
		if output_node:
			eject_object(output_node)
			output_node.plugged_into = null
			output_node = null
		output_node = object
		print(output_node)
		object.plugged_into = self
		object.global_position = $PlugPos.global_position
		if output_node.other_plug.plugged_into and output_node.other_plug.plugged_into.is_output:
			is_output = false
		else:
			is_output = true
		object.update_connections()
		object.freeze = true
		can_insert = false
		$ServeTimer.start()
		$InsertLimit.start()
	elif object.item_resource.battery:
		if inserted_item:
			eject_object(inserted_item)
			inserted_item = null
			can_insert = true
		else:
			inserted_item = object
			item_resource = inserted_item.item_resource
			can_insert = false
			$InsertLimit.start()
			$ServeTimer.start()
			if output_node and output_node.other_plug.plugged_into:
				is_output = !output_node.other_plug.plugged_into.is_output # if other connection is a power source
			object.reparent($InsertPos)
			object.position = Vector3.ZERO
			object.freeze = true
			if "refresh_item" in object:
				object.refresh_item()
	else:
		push_warning("item not compatible with socket. Batteries only!")


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Item") and can_insert:
		insert_item(body)



func _on_insert_limit_timeout() -> void:
	can_insert = true

var power_current := 5

func _on_serve_timer_timeout() -> void:
	if output_node and output_node.plugged_into and inserted_item:
		if inserted_item.item_resource.power >= power_current:
			print("socket is sending")
			output_node.pass_power(power_current)
			inserted_item.update_item()
	else:
		output_node = null
		$ServeTimer.stop()
