extends Area3D

@export var inserted_item: Node3D
var can_insert := true
var output_node: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func eject_object(object) -> void:
	if object.item_resource.plug:
		object.position += Vector3(0, 0.5, 0)
	else:
		object.position = $InsertPos.global_position
		Game.reparent_to_world.emit(object)
	object.freeze = false
	object.linear_velocity = Game.player_last_direction * 5
	var dir = Game.player_last_direction.normalized()
	object.rotation.y = atan2(-dir.x, -dir.z)

func insert_item(object: Node3D) -> void:
	if object.item_resource.plug:
		if output_node:
			eject_object(output_node)
			output_node = null
		output_node = object
		object.global_position = $PlugPos.global_position
		object.freeze = true
		can_insert = false
		$InsertLimit.start()
	else:
		if object.item_resource.battery:
			if inserted_item:
				eject_object(inserted_item)
				inserted_item = null
				can_insert = true
			
			if inserted_item != object:
				inserted_item = object
				can_insert = false
				$InsertLimit.start()
				object.reparent($InsertPos)
				object.position = Vector3.ZERO
				object.freeze = true
				if "refresh_item" in object:
					object.refresh_item()
		else:
			push_warning("item not compatible with socket")


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Item") and can_insert:
		insert_item(body)


func _on_insert_limit_timeout() -> void:
	can_insert = true
