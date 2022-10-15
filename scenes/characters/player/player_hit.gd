extends CanvasLayer

onready var opacity_target = [0.1, 0.2]
var tween_speed = 0.7

#------>FOR TESTING<------
var health = 100 

func _input(event):
	if event is InputEvent and event.is_action_pressed("kick"):
		if not $ColorRect.is_visible_in_tree():
			$ColorRect.show()
		if $AnimationPlayer.is_playing():
			$AnimationPlayer.stop()
		$AnimationPlayer.play("hit_effect")
		
		health -= 5
		
		if health <= 5:
			opacity_target[0] = 0.7
			opacity_target[1] = 0.98
		elif health <= 10:
			tween_speed = 0.4
			opacity_target[0] = 0.6
			opacity_target[1] = 0.8
		elif health <= 15:
			opacity_target[0] = 0.5
			opacity_target[1] = 0.7
		elif health <= 20:
			tween_speed = 0.5
			opacity_target[0] = 0.4
			opacity_target[1] = 0.6
		elif health <= 25:
			opacity_target[0] = 0.3
			opacity_target[1] = 0.5
		elif health <= 30:
			tween_speed = 0.6
			opacity_target[0] = 0.2
			opacity_target[1] = 0.4
		elif health <= 35:
			opacity_target[0] = 0.1
			opacity_target[1] = 0.3
		elif health <= 40:
			if not $TextureRect.is_visible_in_tree():
				$TextureRect.show()
			if not $Tween.is_active() and not $Tween.is_active():
				_start_fade_in()
			opacity_target[0] = 0.05
			opacity_target[1] = 0.2
#------>FOR TESTING<------



func _on_Player_is_hit(current_health):
	if not $ColorRect.is_visible_in_tree():
		$ColorRect.show()
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("hit_effect")
	
	if current_health <= 5:
		opacity_target[0] = 0.7
		opacity_target[1] = 0.98
	elif current_health <= 10:
		tween_speed = 0.4
		opacity_target[0] = 0.6
		opacity_target[1] = 0.8
	elif current_health <= 15:
		opacity_target[0] = 0.5
		opacity_target[1] = 0.7
	elif current_health <= 20:
		tween_speed = 0.5
		opacity_target[0] = 0.4
		opacity_target[1] = 0.6
	elif current_health <= 25:
		opacity_target[0] = 0.3
		opacity_target[1] = 0.5
	elif current_health <= 30:
		tween_speed = 0.6
		opacity_target[0] = 0.2
		opacity_target[1] = 0.4
	elif current_health <= 35:
		opacity_target[0] = 0.1
		opacity_target[1] = 0.3
	elif current_health <= 40:
		if not $TextureRect.is_visible_in_tree():
			$TextureRect.show()
		if not $Tween.is_active() and not $Tween.is_active():
			_start_fade_in()
		opacity_target[0] = 0.05
		opacity_target[1] = 0.2
		

func _start_fade_in():
	$Tween.interpolate_property($TextureRect, "modulate", 
		Color(1, 1, 1, opacity_target[0]), Color(1, 1, 1, opacity_target[1]), tween_speed, Tween.TRANS_SINE, Tween.EASE_OUT)    
	$Tween.start()
	
func _start_fade_out():
	$Tween2.interpolate_property($TextureRect, "modulate", 
		Color(1, 1, 1, opacity_target[1]), Color(1, 1, 1, opacity_target[0]), tween_speed, Tween.TRANS_SINE, Tween.EASE_IN)    
	$Tween2.start()


func _on_Tween_tween_completed(object, key):
	_start_fade_out()


func _on_Tween2_tween_completed(object, key):
	_start_fade_in()