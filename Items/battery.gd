extends RigidBody3D

var item_resource: res_item
const is_output := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_resource = load("res://Items/Battery.tres").duplicate()
	update_item()

func receive_power(amt: int) -> void:
	item_resource.power += amt

func update_item() -> void:
	var new_height = (item_resource.power / 100)
	var scaled_value = new_height * 0.9
	$juice.mesh.height = scaled_value
	$juice.position.y = (-0.4 + $juice.mesh.height/2)
