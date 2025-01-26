extends Control

@export var prompt_resource: res_prompt
@export var time: float

var fade_time := 0.5

func _ready() -> void:
	update_ui()
	Game.update_ui.connect(update_ui)
	Game.dismiss_all_prompts.connect(dismiss)
	if time == 0:
		pass
	else:
		$Timer.start(time)

func update_ui() -> void:
	$Label.text = prompt_resource.message
	
	if Game.input_method == "gamepad":
		$TextureRect.texture = prompt_resource.gamepad_glyph
	else:
		$TextureRect.texture = prompt_resource.keyboard_glyph
		
func dismiss() -> void:
	$Fade.start(fade_time)
	if is_instance_valid(get_tree()):
		var fade_tween = get_tree().create_tween()
		if is_instance_valid(fade_tween):
			fade_tween.tween_property(self, "modulate", Color(1,1,1,0), fade_time)

func _on_fade_timeout() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	dismiss()
