extends Control

func _ready() -> void:
	Game.update_ui.connect(update_ui)
	Game.push_prompt.connect(push_prompt)
	Game.dismiss_all_prompts.connect(dismiss_all_prompts)
	Game.push_dialog.connect(push_dialog)
	Game.lose.connect(lose)
	Game.push_special_dialog.connect(special_dialog)
	initalize_ui()

func lose() -> void:
	$LoseAnim.play("lose_in")
	$LoseBG/Button.grab_focus()
	$LoseBG/Button.disabled = false

func update_ui() -> void:
	pass

func initalize_ui() -> void:
	$dialog.visible = false
	$WifeProfile.visible = false
	$RichTextLabel.visible = false
	$SpecialText.visible = false

func special_dialog(message, delay):
	$SpecialText.text = message
	$SpecialTimer.start(delay)

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


func _on_special_timer_timeout() -> void:
	$SpecialText.visible = true
	$SpecialTimerEnd.start()


func _on_special_timer_end_timeout() -> void:
	$SpecialText.visible = false
