@tool
extends RigidBody3D

@export var item_resource: res_item
@export var input: Node3D
const is_output := false


var is_inserted: bool

func _ready() -> void:
	item_resource = load("res://Items/WorkLight.tres").duplicate()

func receive_power(_amt: int):
	update_item()

func update_item() -> void:
	if input.connected_to_power:
		print("getting powr")
		$ConeLight.active = true
	else:
		$ConeLight.active = false
	$ConeLight.update_item()

func eject_object(object) -> void:
	object.position += Vector3(0, 0.5, 0)
	object.freeze = false
	object.linear_velocity = Game.player_last_direction * 5
	var dir = Game.player_last_direction.normalized()
	object.rotation.y = atan2(-dir.x, -dir.z)

func _process(_delta: float) -> void:
	if input:
		input.global_position = $PlugPos.global_position

func _on_plug_detect_body_entered(body: Node3D) -> void:
	if input:
		pass
	if !input and body.item_resource.plug:
		input = body
		body.freeze = true
		body.plugged_into = self
		body.global_position = $PlugPos.global_position
		update_item()
