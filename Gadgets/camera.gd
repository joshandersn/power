extends Node3D

@export var target: Node3D
@onready var init_target = target
@export var follow_speed := 10.0
@export var distance := 10.0

func pause_and_look(subject, time := 2) -> void:
	target = subject
	get_tree().paused = true
	$Timer.start(time)

func _ready() -> void:
	Game.look_at.connect(pause_and_look)

func _physics_process(delta: float) -> void:
	if target and is_instance_valid(target):
		global_position = lerp(global_position, target.global_position, delta * follow_speed)


func _on_timer_timeout() -> void:
	target = init_target
	get_tree().paused = false
