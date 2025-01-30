extends Control

@export var image: Texture2D
@export var message: String
@export var fade_time = 1

func _ready() -> void:
	update_item()

func update_item() -> void:
	if image and message:
		$Image.texture = image
		$Label.text = message

func dismiss() -> void:
	$Fade.start(fade_time)
	if is_instance_valid(get_tree()):
		var fade_tween = get_tree().create_tween()
		if is_instance_valid(fade_tween):
			fade_tween.tween_property(self, "modulate", Color(1,1,1,0), fade_time)


func _on_fade_timeout() -> void:
	queue_free()
