@tool
extends RigidBody3D

@export var start_active: bool

@export var item_resource: res_item
@export var output_node: Node3D:
	set(value):
		$PlugDetect.output_node = value
		output_node = value

const is_output := false


func _ready() -> void:
	$ConeLight.active = start_active
	$ConeLight.update_item()
	item_resource = load("res://Items/WorkLight.tres").duplicate()

var knocked_over: bool

func prop_back_up() -> void:
	$AnimationPlayer.play("PropUp")

func goblin_action() -> void:
	if !knocked_over:
		$AnimationPlayer.play("knockOver")
		knocked_over = true
		update_item()
	

func receive_power(_amt: int):
	update_item()

func update_item() -> void:
	if output_node:
		if output_node.other_plug.plugged_into and output_node.plugged_into:
			if output_node.other_plug.plugged_into.item_resource.power > 0:
				if knocked_over:
					$ConeLight.active = false
					$Buzz.playing = false
				else:
					$ConeLight.active = true
					$Buzz.playing = true
			else:
				$Buzz.playing = false
				$ConeLight.active = false
		else:
			$ConeLight.active = false
			$Buzz.playing = false
	else:
		$Buzz.playing = false
		$ConeLight.active = false
			
	$Node3D/lightMesh.visible = $ConeLight.active
	$ConeLight.update_item()

func eject_object(object) -> void:
	object.position += Vector3(0, 0.5, 0)
	object.freeze = false
	object.linear_velocity = Game.player_last_direction * 5
	var dir = Game.player_last_direction.normalized()
	object.rotation.y = atan2(-dir.x, -dir.z)

func _process(_delta: float) -> void:
	if output_node:
		output_node.global_position = $PlugPos.global_position
		output_node.global_rotation = $PlugPos.global_rotation

func _on_plug_detect_body_entered(body: Node3D) -> void:
	if output_node:
		pass
	if !output_node and body.item_resource.plug:
		output_node = body
		$plugSound.play()
		body.freeze = true
		body.plugged_into = self
		body.global_position = $PlugPos.global_position
		body.update_connections()
		update_item()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "PropUp":
		knocked_over = false
		update_item()
		
var sound_play = true
func _on_body_entered(body: Node) -> void:
	if sound_play:
		$AudioStreamPlayer3D.play()
		sound_play = true

func _on_audio_stream_player_3d_finished() -> void:
	sound_play = true
