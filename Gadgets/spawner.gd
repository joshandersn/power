extends Node3D

@export var enemy := load("res://Entities/enemy.tscn")
@export var interval := 4

func _ready() -> void:
	$Timer.start(interval)

func spawn_enemy() -> void:
	var new_enemy = enemy.instantiate()
	new_enemy.position = global_position
	new_enemy.get_new_target()
	add_sibling(new_enemy)

func _on_timer_timeout() -> void:
	spawn_enemy()
