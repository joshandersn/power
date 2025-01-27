extends Area3D

@export var active: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_item()
	
func update_item() -> void:
	$SpotLight3D.light_energy = 3 if active else 0


func _on_body_entered(body: Node3D) -> void:
	if active and body.is_in_group("Enemy") and "near_light_source" in body:
		body.near_light_source = true


func _on_death_zone_body_entered(body: Node3D) -> void:
	if active and body.is_in_group("Enemy") and "incenerate" in body:
		body.incenerate()
