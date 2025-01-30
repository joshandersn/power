extends Area3D

@export var push_dialog: String
@export var one_time: bool
@export var load_level: PackedScene

@export var hint_image: Texture2D
@export var hint_message: String

func _on_body_entered(body: Node3D) -> void:
	if "is_player" in body and body.is_player:
		if hint_image and hint_message:
			Game.push_hint.emit(hint_image, hint_message)

		if push_dialog:
			Game.push_dialog.emit(push_dialog)
			
		if one_time:
			set_deferred("monitoring", false)
			
		if load_level:
			Game.load_scene.emit(load_level)
