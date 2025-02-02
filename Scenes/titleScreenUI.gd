extends Control

func _ready() -> void:
	$Play.grab_focus()
	$OptionButton.selected = Game.difficulty

func _on_play_pressed() -> void:
	Game.load_scene.emit(load("res://Scenes/tutorial.tscn"))


func _on_credits_pressed() -> void:
	$CredText.visible = !$CredText.visible


func _on_option_button_item_selected(index: int) -> void:
	Game.difficulty = index
	Game.difficulty_update.emit()
	Game.update_ui.emit()
