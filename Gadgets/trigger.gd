extends Area3D

@export var push_dialog: String
@export var one_time: bool


func _on_body_entered(body: Node3D) -> void:
	if push_dialog:
		Game.push_dialog.emit(push_dialog)
		
	if one_time:
		set_deferred("monitoring", false)
