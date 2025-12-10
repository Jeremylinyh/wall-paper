extends Node2D

@export var damage : int = 10
@export var range : float = 6
@export var swingTime : int = 1

@export var pixaxe : PackedScene

@export var t : float = 0

func _input(event):
	if event.is_action_pressed("Attack") :
		#print("Attack!")
		# Spawn pixaxe
		#var weapon : Node2D = pixaxe.instantiate()
		
		# swing
		var mouse_position : Vector2 = get_global_mouse_position()# get_viewport().get_mouse_position()
		var direction : Vector2 = (mouse_position + $"..".position)
		direction = direction.normalized()
		
		var angle = atan2(direction.y,direction.x) #- PI
		#angle = rad_to_deg(angle)
		#print(angle)
		#
		$AttackAnime.look_at(mouse_position)
		$AttackAnime.rotation -= deg_to_rad(45)
		$AttackAnime.play("Attack")
