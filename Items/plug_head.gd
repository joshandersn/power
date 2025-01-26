extends RigidBody3D

@export var item_resource: res_item
@export var other_plug: Node3D
@export var plugged_into: Node3D

func _ready() -> void:
	item_resource = load("res://Items/PlugHead.tres").duplicate()

func pass_power(amt: int):
	item_resource.power = amt
	if other_plug.plugged_into:
		print("passing to ")
		other_plug.plugged_into.recive_power(amt)
	else:
		print("no output in cable")
