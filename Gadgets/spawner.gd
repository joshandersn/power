extends Node3D

@export var enemy := load("res://Entities/enemy.tscn")
@export var interval := 4

var count: int
@export var limit = 100

func _ready() -> void:
	$Timer.start(interval)

func spawn_enemy() -> void:
	if count <= 100:
		var new_enemy = enemy.instantiate()
		new_enemy.position = global_position
		new_enemy.get_new_target()
		add_sibling(new_enemy)
		count += 1

func _on_timer_timeout() -> void:
	Game.scan_level.emit()
	spawn_enemy()
