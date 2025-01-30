extends Control

func _ready() -> void:
	Game.update_ui.connect(update_ui)
	Game.push_prompt.connect(push_prompt)
	Game.dismiss_all_prompts.connect(dismiss_all_prompts)
	Game.push_dialog.connect(push_dialog)
	Game.lose.connect(lose)
	Game.push_special_dialog.connect(special_dialog)
	Game.push_hint.connect(push_hint)
	initalize_ui()

func lose() -> void:
	$LoseAnim.play("lose_in")
	Game.stop_music.emit()
	$Lose.play()
	await get_tree().create_timer(3).timeout
	$LoseBG/Button.grab_focus()
	$LoseBG/Button.disabled = false
	
func update_ui() -> void:
	pass
	
@onready var hint = load("res://UI/hint.tscn")

func push_hint(image: Texture2D, message: String) -> void:
	var new_hint = hint.instantiate()
	new_hint.image = image
	new_hint.message = message
	clear_hints()
	$Hints.add_child(new_hint)
	$HintTimer.start(5)
	$hint.play()
	
func clear_hints() -> void:
	for i in $Hints.get_children():
		i.dismiss()

func initalize_ui() -> void:
	$dialog.visible = false
	$WifeProfile.visible = false
	$RichTextLabel.visible = false
	$SpecialText.visible = false
	$Pause.visible = false

func special_dialog(message, delay):
	$SpecialText.text = message
	$SpecialTimer.start(delay)
	$SpecialDialog.play()
	
func push_dialog(message) -> void:
	$dialog.visible = true
	$WifeProfile.visible = true
	$RichTextLabel.visible = true
	$DialogAnim.play("dialog_in")
	$RichTextLabel.text = message
	$DialogTimer.start()

func push_prompt(prompt: res_prompt, time := 1) -> void:
	var new_prompt = load("res://UI/prompt.tscn").instantiate()
	new_prompt.prompt_resource = prompt
	new_prompt.time = time
	$Prompts.add_child(new_prompt)

func dismiss_all_prompts() -> void:
	for i in $Prompts.get_children():
		i.dismiss()


func _on_dialog_timer_timeout() -> void:
	$DialogAnim.play("dialog_out")


func _on_dialog_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dialog_out":
		$dialog.visible = false
		$WifeProfile.visible = false
		$RichTextLabel.visible = false


func _on_button_pressed() -> void:
	Game.restart_level.emit()
	$LoseBG/Button.disabled = true
	get_tree().paused = false
	$Pause.visible = get_tree().paused


func _on_special_timer_timeout() -> void:
	$SpecialText.visible = true
	$SpecialTimerEnd.start()


func _on_special_timer_end_timeout() -> void:
	$SpecialText.visible = false


func _on_resume_pressed() -> void:
	get_tree().paused = false
	$Pause.visible = get_tree().paused


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_hint_timer_timeout() -> void:
	clear_hints()
