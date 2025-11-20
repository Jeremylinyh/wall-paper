extends CharacterBody2D

var dead = false
@export var walkSpeed : float = 3.0
@export var endScreen : CanvasLayer

func _process(_delta: float) -> void:
	if dead:
		return
	var moveDirection : Vector2 = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = moveDirection
	move_and_collide(velocity*walkSpeed)
	
	# animate
	if moveDirection.x == 0 and moveDirection.y == 0:
		$CollisionShape2D/AnimatedSprite2D.flip_h = false
		$CollisionShape2D/AnimatedSprite2D.play("default")
	elif moveDirection.x > 0 or moveDirection.y > 0:
		$CollisionShape2D/AnimatedSprite2D.flip_h = false
		$CollisionShape2D/AnimatedSprite2D.play("walk_rightUp")
	else :
		$CollisionShape2D/AnimatedSprite2D.flip_h = true
		$CollisionShape2D/AnimatedSprite2D.play("walk_rightUp")
		
var killed : bool = false
func kill() :
	if killed :
		return
	killed = true
	endScreen.visible = true
	Engine.time_scale = 0
	#await get_tree().create_timer(0.5).timeout
	#get_tree().change_scene_to_file("res://Scenes/MainMenu/menu_screen.tscn")
	#await get_tree().create_timer(0.5).timeout

func getPosition() :
	return position
