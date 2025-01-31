@tool
extends Node3D

@export var redraw_road: bool = false:
	set = _tool_action

@export var road_width := 3
@export var bend := 5

@export var point_a: Node3D
@export var point_b: Node3D

func _ready() -> void:
	if point_a and point_b:
		var new_curve = Curve3D.new()
		new_curve.add_point(point_a.position)
		new_curve.add_point(point_b.position)
		$Path3D.curve = new_curve
		
		draw_road()

func _tool_action(_value: bool):
	redraw_road = false
	draw_road()
	

func draw_road():
	var circle = PackedVector2Array()
	circle.append(Vector2(-road_width/2, -0.5))  # Bottom left
	circle.append(Vector2(road_width/2, -0.5))   # Bottom right
	circle.append(Vector2(road_width/2, 0.5))    # Top right
	circle.append(Vector2(-road_width/2, 0.5))   # Top left
	$CSGPolygon3D.polygon = circle
	
	if point_a and point_b:
		var midpoint = (point_a.position + point_b.position) / 2
		midpoint.x -= bend  # Example: curve upwards by 10 units at midpoint

		if $Path3D.curve.get_point_count() < 3:
			$Path3D.curve.add_point(midpoint)
		else:
			# If the point already exists, just update its position
			$Path3D.curve.set_point_position(1, midpoint)

		$Path3D.curve.set_point_position(0, point_a.position)
		$Path3D.curve.set_point_position(1, midpoint)
		$Path3D.curve.set_point_position(2, point_b.position)
		
		# Adjust the handles of the curve points to control the curve's shape
		$Path3D.curve.set_point_in(0, Vector3(-1, 0, 0))  # Adjust as needed
		$Path3D.curve.set_point_out(0, Vector3(1, 0, 0))  # Adjust as needed
		$Path3D.curve.set_point_in(2, Vector3(-1, 0, 0))  # Adjust as needed
		$Path3D.curve.set_point_out(2, Vector3(1, 0, 0))  # Adjust as needed
