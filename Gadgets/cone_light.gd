extends Area3D

@export var active: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_item()
	
func update_item() -> void:
	$SpotLight3D.light_energy = 1 if active else 0
	monitoring = active
