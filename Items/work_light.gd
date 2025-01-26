@tool
extends RigidBody3D

@export var item_resource: res_item
@export var input: Node3D


var is_inserted: bool

func _ready() -> void:
	item_resource = load("res://Items/WorkLight.tres").duplicate()

func recive_power(_amt: int):
	#item_resource.power += amt
	update_item()

func update_item() -> void:
	print
	if input.item_resource.power:
		$ConeLight.active = true
	else:
		$ConeLight.active = false
	$ConeLight.update_item()

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

func _process(_delta: float) -> void:
	if input:
		input.global_position = $PlugPos.global_position

func _on_plug_detect_body_entered(body: Node3D) -> void:
	if input:
		eject_object(input)
		input = null
	if body.item_resource.plug:
		input = body
		body.freeze = true
		body.plugged_into = self
		body.global_position = $PlugPos.global_position
		update_item()
