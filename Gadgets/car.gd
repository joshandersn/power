extends RigidBody3D 

@export var health := 100
@export var lose_message: String
@export var show_health: bool
var destroyed = false

func _ready() -> void:
	update_item()
	$CarUI.visible = false

var first_attack = false

func goblin_action() -> void:
	if health >= 0:
		health -= 1
		$CarUI/AnimationPlayer.play("damage")
		$hit.play()
		$CarUI.visible = true
		if !first_attack:
			Game.push_dialog.emit("The goblins are ATTACKING the CAR")
		first_attack = true
	elif !destroyed:
		destroyed = true
		$CarUI/AnimationPlayer.play("destroy")
		Game.look_at.emit(self, 4)
		$Timer.start()
	update_item()

func update_item():
	$CarUI.visible = show_health
	$CarUI/ProgressBar.value = health

func _on_timer_timeout() -> void:
	Game.lose.emit()
	Game.push_dialog.emit(lose_message)
