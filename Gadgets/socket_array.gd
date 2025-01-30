extends Area3D

@onready var socket_a = $SocketA
@onready var socket_b = $SocketB
@onready var socket_c = $SocketC

@export var objective: Node3D
@export var objective_clear_message: String


var charged: bool

func socket_filled(socket):
	if socket == null:
		return false
	else:
		return true

@onready var inserts: Array[Node3D]
@onready var sockets = [
	socket_a,
	socket_b,
	socket_c
]

func update_sockets() -> void:
	var count := 0
	for i in inserts.size():
		inserts[count].global_position = sockets[count].global_position
		count += 1
	if inserts.size() == 3:
		charged = true
	$StatusLight.active = charged
	$StatusLight.update_item()
	if charged and objective:
		Game.look_at.emit(objective, 3)
		Game.push_special_dialog.emit(objective_clear_message, 1)
		objective.active = charged
		objective.update_item()

func insert_battery(battery):
	if inserts.size() < 3 and battery.item_resource.power >= 100:
		battery.freeze = true
		battery.inserted_into = self
		battery.is_locked = true
		inserts.append(battery)
		update_sockets()
		$insert.play()
	else:
		var reverse_vel = -battery.linear_velocity
		battery.linear_velocity = reverse_vel

func _on_body_entered(body: Node3D) -> void:
	if body.item_resource.battery:
		insert_battery(body)
