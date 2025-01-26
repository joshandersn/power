extends CharacterBody3D

@export var speed := 3
@export var throw_power := 5


var pickup_field: Array[Node3D]
var picked_up_item: res_item
var can_pickup := true

func pickup(object: Node3D) -> void:
	if picked_up_item:
		drop_item()
	picked_up_item = object.item_resource
	var new_picked_up_item = object.item_resource.scene.instantiate()
	new_picked_up_item.freeze = true
	$PickupPos.add_child(new_picked_up_item)
	object.queue_free()
	can_pickup = false
	$PickupTimer.start()

func clear_pickups() -> void:
	picked_up_item = null
	for i in $PickupPos.get_children():
		i.queue_free()

func drop_item() -> void:
	if picked_up_item:
		var dropped_item = picked_up_item.scene.instantiate()
		dropped_item.position = $PickupPos.global_position
		dropped_item.linear_velocity = last_direction * throw_power
		var dir = last_direction.normalized()
		dropped_item.rotation.y = atan2(-dir.x, -dir.z)
		add_sibling(dropped_item)
		clear_pickups()
	else:
		push_warning("no item is held!")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pickup"):
		if pickup_field.size() >= 1 and can_pickup:
			pickup(pickup_field[0])
		elif picked_up_item:
			drop_item()
		

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
		pickup_field.append(body)
		var modded_prompt = load("res://UI/Prompts/pickup.tres")
		modded_prompt.message = str("Pickup ", body.item_resource.title)
		Game.push_prompt.emit(load("res://UI/Prompts/pickup.tres"), 0)
	else:
		push_warning(body, ' is not a valid item')

func _on_pickup_field_body_exited(body: Node3D) -> void:
	if "item_resource" in body:
		pickup_field.erase(body)
		if pickup_field.size() <= 0:
			Game.dismiss_all_prompts.emit()
	else:
		push_warning(body, ' is not a valid item')


func _on_pickup_timer_timeout() -> void:
	can_pickup = true
