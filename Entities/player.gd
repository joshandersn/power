extends CharacterBody3D

@export var speed := 3
@onready var init_speed = speed
@export var throw_power := 5

var health = 3
var max_health = 3
const is_player = true

var pickup_field: Array[Node3D]
var picked_up_item: Node3D
var held_plug: Node3D
var can_pickup := true
var detected_plug: Node3D

func lose():
	Game.lose.emit()

func goblin_action() -> void:
	if health > 0:
		$Control/VigAnim.play("FadeIn")
		health -= 1
		$RegenTimer.start()
		$Control/Label.text = str(health)
		if health <= 0:
			lose()

func replace_plug_node(object, new_object) -> void:
	if "cable_a" in object.get_parent():
		if object.get_parent().cable_a == object:
			object.get_parent().cable_a = new_object
	if "cable_b" in object.get_parent():
		if object.get_parent().cable_b == object:
			object.get_parent().cable_b = new_object

func pickup(object: Node3D) -> void:
	if "is_locked" in object and object.is_locked:
		pass
	else:
		if "knocked_over" in object and object.knocked_over:
			object.prop_back_up()
		else:
			picked_up_item = object
			object.freeze = true
			if "is_held" in picked_up_item:
				picked_up_item.is_held = true
			detected_plug = null
			can_pickup = false
			if "inserted_into" in object:
				if object.inserted_into:
					object.inserted_into.have_item_removed()
			pickup_field.resize(0)
			$PickupTimer.start()

func throw_item() -> void:
	if picked_up_item:
		picked_up_item.freeze = false
		if "is_held" in picked_up_item:
			picked_up_item.is_held = false
		picked_up_item.linear_velocity = Game.player_last_direction * throw_power
		var dir = Game.player_last_direction.normalized()
		picked_up_item.rotation.y = atan2(-dir.x, -dir.z)
		picked_up_item = null
	else:
		push_warning("no item is held!")

func drop_item() -> void:
	if picked_up_item:
		picked_up_item.global_position = global_position
		picked_up_item.freeze = false
		picked_up_item.linear_velocity = Game.player_last_direction * throw_power/2
		if "is_held" in picked_up_item:
			picked_up_item.is_held = false
		var dir = Game.player_last_direction.normalized()
		picked_up_item.rotation.y = atan2(-dir.x, -dir.z)
		picked_up_item = null
	else:
		push_warning("no item is held!")
		
func unplug_cable():
	if picked_up_item == null:
		if detected_plug:
			detected_plug.disconnect_plug()
			picked_up_item = detected_plug
			detected_plug = null
			if "is_held" in picked_up_item:
				picked_up_item.is_held = true
			Game.dismiss_all_prompts.emit()
	

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pickup"):
		if pickup_field.size() >= 1 and !picked_up_item:
			pickup(pickup_field[0])
		elif picked_up_item:
			drop_item()
	elif Input.is_action_just_pressed("throw") and picked_up_item:
		throw_item()

	if Input.is_action_just_pressed("use_cable"):
		unplug_cable()

	if Input.is_action_just_pressed("jump"):
		if is_on_floor() and health > 0:
			velocity.y += 4
		
	#if Input.is_action_just_pressed("run"):
		#speed = speed*2
	#elif Input.is_action_just_released("run"):
		#speed = init_speed

var idle := false

func _physics_process(delta: float) -> void:
	if picked_up_item:
		picked_up_item.global_position = $PickupPos.global_position
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()



	if direction and health > 0:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		Game.player_last_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if direction.length() > 0.1:
		idle = false
		if picked_up_item:
			if !is_on_floor():
				$Anim.play("JumpCarry")
			else:
				$Anim.play("Carry")
		else:
			if !is_on_floor():
				$Anim.play("Jump")
			else:
				$Anim.play("Run")
	else:
		if !$IdleTimer.time_left:
			$IdleTimer.start()
		if !picked_up_item:
			if idle:
				$Anim.play("IdleLook")
			else:
				if !is_on_floor():
					$Anim.play("Jump")
				else:
					$Anim.play("Idle")
		else:
			if !is_on_floor():
				$Anim.play("Jump")
			else:
				$Anim.play("Idle")
		
	if direction.x > 0.1:
		$Anim.flip_h = false
	elif direction.x < 0.1:
		$Anim.flip_h = true
		

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


func _on_pickup_field_area_entered(area: Area3D) -> void:
	if area.is_in_group("Socket") and area.output_node:
		Game.push_prompt.emit(load("res://UI/Prompts/plug.tres"), 0)
		detected_plug = area.output_node
		
	if area.is_in_group("Socket") and "inserted_item" in area and area.inserted_item:
		Game.push_prompt.emit(load("res://UI/Prompts/pickup.tres"), 0)
		pickup_field.append(area.inserted_item)
		area.update_item()

func _on_pickup_field_area_exited(area: Area3D) -> void:
	if area.is_in_group("Socket"):
		Game.dismiss_all_prompts.emit()
		detected_plug = null
	if area.is_in_group("Socket") and "inserted_item" in area and area.inserted_item:
		pickup_field.erase(area.inserted_item)


func _on_regen_timer_timeout() -> void:
	if health > 0:
		health += 1
		if !$Control/VigAnim.assigned_animation == "FadeOut":
			$Control/VigAnim.play("FadeOut")
		if health >= max_health:
			$RegenTimer.stop()
		$Control/Label.text = str(health)
	


func _on_idle_timer_timeout() -> void:
	idle = true


func _on_anim_animation_looped() -> void:
	if $Anim.animation == "IdleLook":
		idle = false
