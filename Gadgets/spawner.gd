extends Node3D

@export var enemy := load("res://Entities/enemy.tscn")
@export var interval := 4

@export var limit = 100

func _ready() -> void:
	$Timer.start(interval)
	Game.difficulty_update.connect(diff)
	diff()

func diff():
	if Game.difficulty == 0:
		limit = 25
		interval = 10
	elif Game.difficulty == 1:
		limit = 50
		interval = 5
	elif Game.difficulty == 2:
		limit = 100
		interval = 4

func spawn_enemy() -> void:
	if (Game.enemy_count - Game.goblin_kills) <= limit:
		var new_enemy = enemy.instantiate()
		new_enemy.position = global_position
		new_enemy.get_new_target()
		add_sibling(new_enemy)
		Game.enemy_count += 1
		$Timer.start(interval)
		

func _on_timer_timeout() -> void:
	Game.scan_level.emit()
	spawn_enemy()
