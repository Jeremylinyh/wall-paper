extends Node2D

@export var damage : int = 10
@export var range : float = 6
@export var swingTime : int = 1

@export var pixaxe : PackedScene

@export var t : float = 0

func _input(event):
	if event.is_action_pressed("Attack") :
		print("Attack!")
		# Spawn pixaxe
		var weapon : Node2D = pixaxe.instantiate()
		
		# swing
		var mouse_position : Vector2 = get_viewport().get_mouse_position()
		var direction : Vector2 = (mouse_position - $"..".position)
		direction = direction.normalized()
		
		var vertexPos : Vector2 = $"..".position + direction
		
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(self,"t",2 * PI,1)
		tween.play()
		# destroy pixaxe
