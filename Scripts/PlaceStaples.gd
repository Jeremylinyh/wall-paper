extends TextureButton

@export var parentTo : Node2D
@export var toBePlaced : PackedScene
@export var picture : Texture

@export var helthAmount : float = 300
@export var costPosition : bool = true
@export var MapNode : Node2D
## what funcotionalities will our new tower have??
@export var mustContain : Array[PackedScene]
@export var projectileHolder : Node2D
@export var mobSpawner : Node2D

@export var projectilePicture : Texture
@export var cost : float = 100
@onready var occupiedChecker = $".."
#var mouseCurrPos : Vector2 = Vector2()
var isPlacing : bool = false
func _round_Vector_2(inVec : Vector2) : 
	return Vector2(roundf(inVec.x),roundf(inVec.y))

#func _input(event: InputEvent) -> void:
	#
	#if event is InputEventMouseMotion:
		#mouseCurrPos = (event.position)
	#else :
		#return
		#
	## now we need to snap to the grid of 64x64
	#mouseCurrPos = (mouseCurrPos + Vector2(32,32))/ 64
	#mouseCurrPos = _round_Vector_2(mouseCurrPos)*64
	#print(mouseCurrPos)
var newPlacer : Node2D = null
func _on_pressed() -> void:
	#print(isPlacing)
	if MapNode.playerMaterial < cost :
		return
	MapNode.playerMaterial -= cost
	
	isPlacing = not isPlacing
	if not isPlacing :
		newPlacer = null
		return
	
	newPlacer = toBePlaced.instantiate()
	#print(newPlacer)
	#print("pressed")
	parentTo.add_child(newPlacer)
	#print(newPlacer.get_parent())
	#while isPlacing :
		#parentTo.position = mouseCurrPos
		#await get_tree().create_timer(1.0).timeout

func _process(_delta: float) -> void:
	if not newPlacer :
		return
	if not isPlacing:
		return
	#print(newPlacer)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) :
		print("Cancel placing")
		
		newPlacer.queue_free()
		MapNode.playerMaterial += cost
		newPlacer = null
		isPlacing = false
		return
	
	var mouse_world_pos : Vector2 = parentTo.get_viewport().get_camera_2d().get_global_mouse_position()
	mouse_world_pos = _round_Vector_2((mouse_world_pos/64.0) - Vector2(0.5,0.5))*64.0
	#print(mouse_world_pos)
	newPlacer.position = mouse_world_pos
	newPlacer.picture = picture
	newPlacer.setCollisionLayer(5,true)
	newPlacer.setCollisionLayer(17,true)
	newPlacer.setCollisionMask(17,true)
	newPlacer.setCollisionLayer(4,false)##
	newPlacer.setCollisionMask(4,false)##
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) :
		if occupiedChecker.checkIfPositionInvalid(newPlacer.position) :
			print("attempted to place in already occupied position")
			newPlacer.queue_free()
			return
		if costPosition :
			occupiedChecker.addOccupiedPosition(newPlacer.position)
			newPlacer.tree_exiting.connect(occupiedChecker.disOccupy.bind(newPlacer.position))
		
		# add functionalities
		for ability in mustContain :
			var newAbility = ability.instantiate()
			newPlacer.add_child(newAbility)
			#must satisfy:
			#@export var Mob_spawner : Node2D
			#@export var parentTo : Node2D
			if newAbility.name == "ShootProjectile":
				newAbility.Mob_spawner = mobSpawner
				newAbility.parentTo = projectileHolder
				newAbility.projectilePicture = projectilePicture
			elif newAbility.name == "Helth" :
				pass
				newAbility.totalHealth = helthAmount
				newAbility.currentHealth = helthAmount
			elif newAbility.name == "MoveTowardPlayerBlind" :
				pass#newAbility.defaultSpeed = 3.141592653589793 * 6.0
				
			
		
		newPlacer.disableCollision(false)
		newPlacer = null
		isPlacing = false
	
