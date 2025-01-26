extends Area3D

@export var inserted_item: res_item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func insert_item(object: res_item) -> void:
	if inserted_item:
		for i in $InsertPos.get_children():
			i.queue_free()
		var eject_item = inserted_item.scene.instantiate()
		eject_item.linear_velocity = Game.player_last_direction * 5
		eject_item.position = $InsertPos.global_position
		var dir = Game.player_last_direction.normalized()
		eject_item.rotation.y = atan2(-dir.x, -dir.z)
		add_sibling(eject_item)
	inserted_item = object
	var item_inst = object.scene.instantiate()
	item_inst.freeze = true
	if "refresh_item" in item_inst:
		item_inst.refresh_item()
	$InsertPos.add_child(item_inst)

var can_insert := true

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Item") and can_insert:
		insert_item(body.item_resource)
		body.queue_free()
		can_insert = false
		$InsertLimit.start()


func _on_insert_limit_timeout() -> void:
	can_insert = true
