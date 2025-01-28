extends RigidBody3D 

@export var health := 100
@export var lose_message: String

var destroyed = false
func goblin_action() -> void:
	if health >= 0:
		health -= 1
	elif !destroyed:
		destroyed = true
		Game.look_at.emit(self, 4)
		$Timer.start()

func _on_timer_timeout() -> void:
	Game.lose.emit()
	Game.push_dialog.emit(lose_message)
