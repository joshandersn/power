extends Control

func _ready() -> void:
	Game.update_ui.connect(update_ui)
	Game.push_prompt.connect(push_prompt)
	Game.dismiss_all_prompts.connect(dismiss_all_prompts)

func update_ui() -> void:
	pass

func push_prompt(prompt: res_prompt, time := 1) -> void:
	var new_prompt = load("res://UI/prompt.tscn").instantiate()
	new_prompt.prompt_resource = prompt
	new_prompt.time = time
	$Prompts.add_child(new_prompt)
	print("prompting")

func dismiss_all_prompts() -> void:
	for i in $Prompts.get_children():
		i.dismiss()
