extends RigidBody3D 

@export var health := 100
@export var lose_message: String

func goblin_action() -> void:
	health -= 1
	if health <= 0:
		Game.lose.emit()
		Game.push_dialog.emit(lose_message)
