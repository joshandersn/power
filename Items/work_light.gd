@tool
extends RigidBody3D

@export var item_resource: res_item

func _ready() -> void:
	item_resource = load("res://Items/WorkLight.tres").duplicate()
