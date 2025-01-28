extends RigidBody3D

var item_resource: res_item
const is_output := true
var inserted_into: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_resource = load("res://Items/Battery.tres").duplicate()
	update_item()

func receive_power(amt: int) -> void:
	item_resource.power += amt
	update_item()

func update_item() -> void:
	var new_height = (item_resource.power / 100)
	var scaled_value = new_height * 0.65
	$juice.mesh.height = scaled_value
	$juice.position.y = $juice.mesh.height/2 - 0.25
	
	$OmniLight.active = !!(item_resource.power > 50)
	$OmniLight.update_item()
