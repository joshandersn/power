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
	
	var distance = (cable_a.global_position - cable_b.global_position)
	if cable_a.is_held and distance.length() > 2:
		cable_b.linear_velocity = distance
	elif cable_b.is_held and distance.length() > 2:
		cable_a.linear_velocity = -distance
	
	var circle = PackedVector2Array()
	for degree in line_resolution:
		var x = line_radius * sin(PI * 2 * degree / line_resolution)
		var y = line_radius * cos(PI * 2 * degree / line_resolution)
		var coords = Vector2(x,y)
		circle.append(coords)
	$CSGPolygon3D.polygon = circle
	
	if cable_a and cable_b:

		var midpoint = (cable_a.position + cable_b.position) / 2
		midpoint.x += 1  # Example: curve upwards by 10 units at midpoint

		if $Path3D.curve.get_point_count() < 3:
			$Path3D.curve.add_point(midpoint)
		else:
			# If the point already exists, just update its position
			$Path3D.curve.set_point_position(1, midpoint)

		$Path3D.curve.set_point_position(0, cable_a.position)
		$Path3D.curve.set_point_position(1, midpoint)
		$Path3D.curve.set_point_position(2, cable_b.position)
		
		# Adjust the handles of the curve points to control the curve's shape
		$Path3D.curve.set_point_in(0, Vector3(-1, 0, 0))  # Adjust as needed
		$Path3D.curve.set_point_out(0, Vector3(1, 0, 0))  # Adjust as needed
		$Path3D.curve.set_point_in(2, Vector3(-1, 0, 0))  # Adjust as needed
		$Path3D.curve.set_point_out(2, Vector3(1, 0, 0))  # Adjust as needed
		
