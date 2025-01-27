extends CharacterBody3D

@export var speed := 0.5
@export var target: Node3D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var input_dir: Vector3
	if target:
		input_dir = -(position - target.position)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.z)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func _on_detection_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		target = body
