@tool
extends RigidBody3D

@export var item_resource: res_item
@export var output_node: Node3D:
	set(value):
		$PlugDetect.output_node = value
		output_node = value

const is_output := false


func _ready() -> void:
	item_resource = load("res://Items/WorkLight.tres").duplicate()

func receive_power(_amt: int):
	update_item()

func update_item() -> void:
	if output_node:
		if output_node.other_plug.plugged_into and output_node.plugged_into:
			if output_node.other_plug.plugged_into.item_resource.power:
				$ConeLight.active = true
			else:
				$ConeLight.active = false
		else:
			$ConeLight.active = false
	else:
		$ConeLight.active = false
			
	$lightMesh.visible = $ConeLight.active
	$ConeLight.update_item()

func eject_object(object) -> void:
	object.position += Vector3(0, 0.5, 0)
	object.freeze = false
	object.linear_velocity = Game.player_last_direction * 5
	var dir = Game.player_last_direction.normalized()
	object.rotation.y = atan2(-dir.x, -dir.z)

func _process(_delta: float) -> void:
	if output_node:
		output_node.global_position = $PlugPos.global_position

func _on_plug_detect_body_entered(body: Node3D) -> void:
	if output_node:
		pass
	if !output_node and body.item_resource.plug:
		output_node = body
		body.freeze = true
		body.plugged_into = self
		body.global_position = $PlugPos.global_position
		body.update_connections()
		update_item()
