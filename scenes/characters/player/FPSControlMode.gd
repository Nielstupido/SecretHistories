extends ControlMode

export var _aimcast : NodePath
onready var aimcast : RayCast = get_node(_aimcast) as RayCast

export var mouse_sensitivity = 0.01
var pitch_yaw : Vector2 = Vector2.ZERO
const rad_deg = rad2deg(1.0);



func set_active(value : bool):
	.set_active(value)
	if value:
		pitch_yaw.x = 0.0
		pitch_yaw.y = owner.body.rotation.y
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _notification(what):
	if is_active:
		if what == NOTIFICATION_PAUSED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif what == NOTIFICATION_UNPAUSED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		pitch_yaw.x -= event.relative.y*mouse_sensitivity
		pitch_yaw.y -= event.relative.x*mouse_sensitivity
		pitch_yaw.x = clamp(pitch_yaw.x, -PI*0.5, PI*0.5)
		pitch_yaw.y = wrapf(pitch_yaw.y, -PI, PI)

func update():
	owner.body.rotation.y = pitch_yaw.y
	camera.rotation.x = pitch_yaw.x
	if aimcast.is_colliding():
		owner.equipment_root.look_at(aimcast.get_collision_point(), Vector3.UP)
	else:
		owner.equipment_root.global_transform.basis = camera.global_transform.basis
	pass

func get_movement_basis() -> Basis:
	return Basis.IDENTITY.rotated(Vector3.UP, pitch_yaw.y)

func get_interaction_target() -> Node:
	return aimcast.get_collider() as Node