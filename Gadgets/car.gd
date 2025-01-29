extends RigidBody3D 

@export var health := 100
@export var lose_message: String
@export var show_health: bool
var destroyed = false

func _ready() -> void:
	update_item()

func goblin_action() -> void:
	if health >= 0:
		health -= 1
		$CarUI/AnimationPlayer.play("damage")
	elif !destroyed:
		destroyed = true
		Game.look_at.emit(self, 4)
		$Timer.start()
	update_item()

func update_item():
	$CarUI.visible = show_health
	$CarUI/ProgressBar.value = health

func _on_timer_timeout() -> void:
	Game.lose.emit()
	Game.push_dialog.emit(lose_message)
