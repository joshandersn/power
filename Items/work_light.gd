@tool
extends RigidBody3D

@export var item_resource: res_item

func _ready() -> void:
	item_resource = load("res://Items/WorkLight.tres").duplicate()

func _process(delta: float) -> void:
	#if Engine.is_editor_hint():
		#rotate_y(0.1)
	pass
