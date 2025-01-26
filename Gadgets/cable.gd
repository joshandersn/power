extends Node3D

@export var line_radius := 0.1
@export var line_resolution := 64

@export var cable_a: Node3D
@export var cable_b: Node3D

func _ready() -> void:
	if cable_a and cable_b:
		var new_curve = Curve3D.new()
		new_curve.add_point(cable_a.position)
		new_curve.add_point(cable_b.position)
		$Path3D.curve = new_curve

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var circle = PackedVector2Array()
	for degree in line_resolution:
		var x = line_radius * sin(PI * 2 * degree / line_resolution)
		var y = line_radius * cos(PI * 2 * degree / line_resolution)
		var coords = Vector2(x,y)
		circle.append(coords)
	$CSGPolygon3D.polygon = circle
	
	if cable_a and cable_b:
		$Path3D.curve.set_point_position(0, cable_a.position)
		$Path3D.curve.set_point_position(1, cable_b.position)
