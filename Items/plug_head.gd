extends RigidBody3D

@export var item_resource: res_item
@export var other_plug: Node3D
@export var plugged_into: Node3D


func pass_power(amt: int):
	if plugged_into and "recive_power" in plugged_into:
		plugged_into.recive_power(amt)
	elif other_plug.plugged_into:
		other_plug.pass_power(amt)
	else:
		print("no output in cable")

func _ready() -> void:
	item_resource = load("res://Items/PlugHead.tres").duplicate()
