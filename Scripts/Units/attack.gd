extends Node2D

@export var damage : int = 10

func _input(event):
	if event.is_action_pressed("Attack") :
		pass
		print("Attack!")
