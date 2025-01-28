extends CharacterBody3D

@export var speed := 1.5
@export var target: Node3D

var near_light_source: bool
var is_hesitant: bool

func incenerate() -> void:
	queue_free()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var input_dir: Vector3
	if target:
		if abs(position - target.position) > Vector3(0.4, 0.4, 0.4):
			if !is_hesitant:
				if near_light_source:
					input_dir = (position - target.position)
					if !$FearTimer.time_left:
						$FearTimer.start()
				else:
					input_dir = -(position - target.position)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.z)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

var random = RandomNumberGenerator.new()

func _on_detection_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		target = body


func _on_fear_timer_timeout() -> void:
	near_light_source = false
	is_hesitant = true
	$HesitateTimer.start()

func _on_hesitate_timer_timeout() -> void:
	is_hesitant = false
	var r = random.randf_range(0, 1)
	print(Game.enemy_count)
	for i in Game.defences:
		if r > 0.5:
			target = i
		else:
			target = null

var reached_player: Node3D

func _on_hitbox_body_entered(body: Node3D) -> void:
	if "is_player" in body:
		reached_player = body
		if !$HitTimer.time_left:
			$HitTimer.start()

func _on_hitbox_body_exited(body: Node3D) -> void:
	if "is_player" in body:
		reached_player = null
		$HitTimer.stop()

func _on_hit_timer_timeout() -> void:
	if reached_player:
		reached_player.take_damage()
		
