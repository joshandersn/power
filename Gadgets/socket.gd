extends Area3D

@export var inserted_item: Node3D
var can_insert := true
var outputs: Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func insert_item(object: Node3D) -> void:
	if object.item_resource.plug:
		pass
	else:
		if inserted_item:
			print("there is an item here: ", inserted_item)
			Game.reparent_to_world.emit(inserted_item)
			inserted_item.freeze = false
			inserted_item.linear_velocity = Game.player_last_direction * 5
			inserted_item.position = $InsertPos.global_position
			var dir = Game.player_last_direction.normalized()
			inserted_item.rotation.y = atan2(-dir.x, -dir.z)
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
