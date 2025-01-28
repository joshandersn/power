extends RigidBody3D 

@export var health := 100
@export var lose_message: String

var destroyed = false
func goblin_action() -> void:
	if health >= 0:
		health -= 1
	elif !destroyed:
		destroyed = true
		Game.lose.emit()
		Game.push_dialog.emit(lose_message)
