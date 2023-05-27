class_name SoundListener
extends Node


export var sensor : NodePath
onready var player_sight_sensor : PlayerSensor = get_node(sensor) as PlayerSensor

var sound_detected : bool = false
var sensor_up_to_date : bool = false
var sound_position : Vector3 = Vector3.ZERO
var player_near : bool = false
var player_inside_listener : bool = false
var item_inside_listener = []
var item_too_near = []
var player_body : Object
var item_heared : Object
var sound_was_heared : bool = false


func _ready():
	queue_update()
	get_tree().connect("idle_frame", self, "clear_sensor")


func queue_update():
	if not is_inside_tree():
		yield(self, "ready")
	if not get_tree().is_connected("idle_frame", self, "_update"):
		get_tree().connect("idle_frame", self, "_update", [], CONNECT_ONESHOT)


func _update():
	set_fov()


func set_fov():
	queue_update()


func is_sound_detected() -> bool:
	if not sound_was_heared:
		if not sensor_up_to_date:
			update_sensor()
	
	return sound_detected


func get_measured_position() -> Vector3:
	if not sound_was_heared:
		if not sensor_up_to_date:
			update_sensor()
	
	return sound_position


func update_sensor():
	sound_detected = false
	check_sound_around()
	sensor_up_to_date = true


func clear_sensor():
	sensor_up_to_date = false


func check_sound_around():
	if player_inside_listener:
		if obj_sound_loud_enough(player_body, check_if_behind_wall(player_body)):
			sound_detected = true
			sound_was_heared = true
			sound_position = player_body.global_transform.origin
	
	for item in item_inside_listener:
		if obj_sound_loud_enough(item, check_if_behind_wall(item)):
			sound_detected = true
			sound_was_heared = true
			sound_position = item.global_transform.origin


func obj_sound_loud_enough(item, behind_wall : bool):
	if behind_wall:
		item.noise_level /= 2
	
	if item.noise_level >= 4:
		return true 
	return false


func check_if_behind_wall(obj : Object):
	if item_too_near.has(obj):
		return false
		
	var space_state = owner.get_world().direct_space_state
	var result = (space_state.intersect_ray(owner.global_transform.origin + Vector3.UP * 1.5, 
			obj.global_transform.origin, [owner]))
	if result:
		if (result["collider"].name == "wall_xp" or result["collider"].name == "wall_zp" or 
				result["collider"].name == "wall_xn" or result["collider"].name == "wall_zn"):
			return true
	return false


func _on_FarSoundDetector_body_entered(body):
	if body is Player:
		player_body = body
		player_inside_listener = true
	
	if body is ToolItem or body is GunItem or body is MeleeItem or body is EquipmentItem or body is BombItem:
		if not item_inside_listener.has(body):
			item_inside_listener.append(body)


func _on_FarSoundDetector_body_exited(body):
	if body is Player:
		player_inside_listener = false
	
	if body is ToolItem or body is GunItem or body is MeleeItem or body is EquipmentItem or body is BombItem:
		if item_inside_listener.has(body):
			item_inside_listener.remove(item_inside_listener.find(body))


func _on_PlayerDetector_body_entered(body):
	if body is ToolItem or body is GunItem or body is MeleeItem or body is EquipmentItem or body is BombItem:
		if not item_too_near.has(body):
			item_too_near.append(body)


func _on_PlayerDetector_body_exited(body):
	if body is ToolItem or body is GunItem or body is MeleeItem or body is EquipmentItem or body is BombItem:
		if item_too_near.has(body):
			item_too_near.remove(item_too_near.find(body))
