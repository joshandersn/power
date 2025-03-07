extends CharacterBody3D

@export var speed := 1.5
@export var hit_freq := 0.2
@export var target: Node3D

var near_light_source: bool
var is_hesitant: bool
var is_stunned: bool

var being_killed := false

@export var tutorial_object: Node3D

func tutorial_tool():
	if is_instance_valid(tutorial_object) and tutorial_object:
		tutorial_object.queue_free()

func _ready() -> void:
	difficulty_update()
	Game.difficulty_update.connect(difficulty_update)

func difficulty_update() -> void:
	if Game.difficulty == 0:
		hit_freq = 1.5
		speed = 1.5
	elif Game.difficulty == 1:
		hit_freq = 0.5
		speed = 2
	elif Game.difficulty == 2:
		hit_freq = 0.2
		speed = 2.3

func incenerate() -> void:
	if !being_killed:
		tutorial_tool()
		being_killed = true
		randomize()
		if (randi() % 2):
			$die.stream = load("res://Sound/goblinDie1.wav")
		else:
			$die.stream = load("res://Sound/goblinDie2.wav")
		$die.play()
		$Anim.play("Die")


func take_damage() -> void:
	if !is_stunned:
		is_stunned = true
		$StunTime.start()
		$Anim.play("Stun")
		if (randi() % 2):
			$die.stream = load("res://Sound/goblinGrunt.wav")
		else:
			$die.stream = load("res://Sound/goblinGrunt2.wav")
		$die.play()
		$hit.play()
	else:
		incenerate()

func _physics_process(delta: float) -> void:
	if !being_killed:
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		var input_dir: Vector3
		if target and is_instance_valid(target):
			if !is_stunned:
				if (position - target.position).length() > 1:
					if !is_hesitant:
						if near_light_source:
							input_dir = (position - target.position)
							if !$FearTimer.time_left:
								$FearTimer.start()
						else:
							input_dir = -(position - target.position)

		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.z)).normalized()
		
		if !being_killed:
			if !is_stunned:
				if velocity.length() > 0.8:
					$Anim.play("Run")
					$Anim.pixel_size = 0.0015
				else:
					$Anim.play("Idle")
					$Anim.pixel_size = 0.0018
				
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)


		if direction.x > 0.1:
			$Anim.flip_h = false
		elif direction.x < 0.1:
			$Anim.flip_h = true

		move_and_slide()
	
func get_new_target() -> void:
	randomize()
	var rindex = randi() % Game.defences.size()
	target = Game.defences[rindex]

func _on_detection_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		target = body


func _on_fear_timer_timeout() -> void:
	near_light_source = false
	is_hesitant = true
	$HesitateTimer.start()
	

func _on_hesitate_timer_timeout() -> void:
	is_hesitant = false
	get_new_target()

var reached_target: Node3D

func _on_hitbox_body_entered(body: Node3D) -> void:
	if "is_player" in body or body.is_in_group("Defence"):
		reached_target = body
		if !$HitTimer.time_left:
			$HitTimer.start(hit_freq)

func _on_hitbox_body_exited(body: Node3D) -> void:
	if "is_player" in body or body.is_in_group("Defence"):
		reached_target = null
		$HitTimer.stop()

func _on_hit_timer_timeout() -> void:
	if reached_target and !is_stunned:
		reached_target.goblin_action()
		randomize()
		if (randi() % 2):
			get_new_target()
		


func _on_stun_time_timeout() -> void:
	is_stunned = false


func _on_anim_animation_looped() -> void:
	if $Anim.animation == "Stun":
		$Anim.play("OnGround")
	
	if $Anim.animation == "Die":
		Game.goblin_kills += 1
		Game.check_level_objective.emit()
		queue_free()
