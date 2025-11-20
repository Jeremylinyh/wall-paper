extends Node2D

@onready var enemyUnit : CharacterBody2D = $".."
var player
@export var defaultSpeed : float = 3.0;

var path : Array
var index : int = 0
var length : int = 0

func _round_Vector_2(inVec : Vector2) : 
	return Vector2(roundf(inVec.x),roundf(inVec.y))

func _ready() -> void:
	player = get_tree().root.get_node("Map").getCurrentPlayer()
	#while true :
		#
		#var plrPos : Vector2 = (_round_Vector_2(player.getPosition()/64.0) - Vector2(0.5,0.5))*1.0
		#var enemyPos : Vector2 = (_round_Vector_2(enemyUnit.position/64.0) - Vector2(0.5,0.5))*1.0#Vector2(roundf(enemyUnit.position.x),roundf(enemyUnit.position.y))/64.0
		#
		##await get_tree().create_timer(10).timeout
		#print(plrPos,enemyPos)
		##plrPos = Vector2.DOWN
		##enemyPos = Vector2.UP
		#path = await $"AI slop".find_path(plrPos,enemyPos)
		#
		#length = path.size()
		#while index < length :
			#print(index,length)
			#await get_tree().create_timer(0.3).timeout
	#print(enemyUnit)

func _process(delta: float) -> void:
	if not player :
		return
	#if path.size() <= index:
		#return
	#var relativeDirection : Vector2 = (path[index] * 64.0 - enemyUnit.position * 64.0)
	var relativeDirection : Vector2 = (player.getPosition()-enemyUnit.position)
	
	var distanceToWp = relativeDirection.length()
	if distanceToWp < 0.1 :
		index += 1
		if index <= length :
			return
	
	relativeDirection = relativeDirection.normalized()
	relativeDirection *= defaultSpeed * delta * 60.0
	
	enemyUnit.velocity = relativeDirection
	enemyUnit.move_and_collide(relativeDirection)
	
	#enemyUnit.move_and_slide()
