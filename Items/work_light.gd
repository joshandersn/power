@tool
extends RigidBody3D

@export var item_resource: res_item
@export var input: Node3D

func _ready() -> void:
	item_resource = load("res://Items/WorkLight.tres").duplicate()

func update_item() -> void:
	$ConeLight.active = !!(input.power > 0)
