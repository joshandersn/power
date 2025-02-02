extends RigidBody3D
@export var can_pickup := true

@export var item_resource: res_item
@export var other_plug: Node3D
@export var plugged_into: Node3D
@export var is_reciever: bool
@export var is_held: bool
var connected_to_power: bool
@onready var plug_pos = $PlugPos

func _ready() -> void:
	item_resource = load("res://Items/PlugHead.tres").duplicate()

func update_connections():
	if plugged_into and "update_item" in plugged_into:
		plugged_into.update_item()
	if other_plug.plugged_into and "update_item" in other_plug.plugged_into:
		other_plug.plugged_into.update_item()
		

func pass_power(amt: int):
	if other_plug.plugged_into and plugged_into:
		if other_plug.plugged_into.is_output:
			if plugged_into and "recevie_power" in plugged_into:
				other_plug.plugged_into.item_resource.power -= amt
				plugged_into.receive_power(amt)
		elif plugged_into.is_output:
			if other_plug.plugged_into and "receive_power" in other_plug.plugged_into:
				plugged_into.item_resource.power -= amt
				other_plug.plugged_into.receive_power(amt)
		update_connections()
		

func get_current():
	if connected_to_power and other_plug.plugged_into:
		return true
	else:
		return false
		

func disconnect_plug() -> void:
	var recent_plug = plugged_into
	plugged_into = null
	recent_plug.output_node = null
	$plugsound.play()
	if other_plug.plugged_into and "update_item" in other_plug.plugged_into:
		other_plug.plugged_into.update_item()
	if "update_item" in recent_plug:
		recent_plug.update_item()
		
var sound_play = true
func _on_body_entered(_body: Node) -> void:
	if sound_play:
		$AudioStreamPlayer3D.play()
		sound_play = true

func _on_audio_stream_player_3d_finished() -> void:
	sound_play = true
	
