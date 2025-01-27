extends RigidBody3D

@export var item_resource: res_item
@export var other_plug: Node3D
@export var plugged_into: Node3D
@export var is_reciever: bool
var connected_to_power: bool

func _ready() -> void:
	item_resource = load("res://Items/PlugHead.tres").duplicate()

func pass_power(amt: int):
	connected_to_power = true
	other_plug.connected_to_power = true
	if plugged_into and plugged_into.is_output:
		if other_plug.plugged_into:
			other_plug.plugged_into.receive_power(amt)
	elif other_plug.plugged_into.is_output:
		plugged_into.receive_power(amt)

func get_current():
	if connected_to_power and other_plug.plugged_into:
		return true
	else:
		return false
		

func disconnect_plug() -> void:
	connected_to_power = false 
	var recent_plug = plugged_into
	plugged_into = null
	if "update_item" in recent_plug:
		recent_plug.update_item()
	if other_plug.plugged_into and "update_item" in other_plug.plugged_into:
		other_plug.plugged_into.update_item()
