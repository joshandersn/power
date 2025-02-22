extends Area3D

@export var active: bool
@export var max_light := 10.0
@export var light_color := Color(1, 1, 1)

	
var near_array: Array[Node3D]
var incenerate_array: Array[Node3D]

func update_item() -> void:
	$SpotLight3D.light_energy = max_light if active else 0.0
	$SpotLight3D.light_color = light_color
	if active:
		for i in near_array:
			if is_instance_valid(i):
				i.near_light_source = true

		for i in incenerate_array:
			if is_instance_valid(i):
				i.incenerate()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy") and "near_light_source" in body:
		near_array.append(body)
		if active:
			body.near_light_source = true

func _on_death_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy") and "incenerate" in body:
		incenerate_array.append(body)
		if active:
			body.incenerate()
