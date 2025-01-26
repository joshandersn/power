extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.reparent_to_world.connect(reparent_to_world)

func reparent_to_world(object: Node3D):
	object.reparent(self)
