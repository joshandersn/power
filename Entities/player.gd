extends CharacterBody3D

@export var speed := 3

var pickup_field: Array[res_item]

func pickup(object: res_item) -> void:
	var picked_up_item = object.scene.instantiate()
	picked_up_item.freeze = true
	$PickupPos.add_child(picked_up_item)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pickup"):
		if pickup_field.size() > 0:
			pickup(pickup_field[0])

var last_direction: Vector3

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		last_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func _on_pickup_field_body_entered(body: Node3D) -> void:
	if "item_resource" in body:
		pickup_field.append(body.item_resource)
		var modded_prompt = load("res://UI/Prompts/pickup.tres")
		modded_prompt.message = str("Pickup ", body.item_resource.title)
		Game.push_prompt.emit(load("res://UI/Prompts/pickup.tres"), 0)
		print("found", pickup_field)
	else:
		push_warning(body, ' is not a valid item')

func _on_pickup_field_body_exited(body: Node3D) -> void:
	if "item_resource" in body:
		pickup_field.erase(body.item_resource)
		if pickup_field.size() <= 0:
			Game.dismiss_all_prompts.emit()
	else:
		push_warning(body, ' is not a valid item')
