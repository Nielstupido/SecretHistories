extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var character : Character = get_parent() as Character

onready var equipment = get_node("../Body/Shotgun")

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_movement()
	handle_equipment()

func handle_movement():
	var direction : Vector3 = Vector3.ZERO
	direction.x += Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.z += Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction = direction.normalized()*min(1.0, direction.length())
	if not Input.is_action_pressed("sprint"):
		direction *= 0.5;
	character.character_state.move_direction = direction
		
func handle_equipment():
	if Input.is_action_just_pressed("attack"):
		if equipment is Gun:
			equipment.shoot()
	pass
