extends Node2D

@export var baseEnemy : PackedScene
@export var initialGracePeriodLEngth : float = 6.0
@export var sequence : Array[Vector2] ## amount of time, wait between enemy spawn

var waitBetweenEnemySpawns : float = 1.0

@export var playerCharacter : Node2D 
@export var paperEnemyFeatures : Array[PackedScene]
@export var paperEnemySprite : Texture

var rng = RandomNumberGenerator.new()

var enemyIsBigChance : float = 0.3

func selectRandomPositionYes() :
	var centerPointe : Vector2 = playerCharacter.getPosition()
	pass

func placeEnemyRelativeToPlr() :
	if not playerCharacter:
		return Vector2()
	const offset : float = 0
	
	var viewport_size = get_viewport().size
	var viewport_width = viewport_size.x + offset
	var viewport_height = viewport_size.y + offset
	
	# now we generate a random angle or something
	var angle = rng.randf() * 2.0 * PI
	var vec : Vector2 = Vector2(cos(angle) * viewport_width,sin(angle) * viewport_height)
	return vec + playerCharacter.getPosition()

func periodical_table() :
	while true :
		var newEnemy = baseEnemy.instantiate()
		newEnemy.setCollisionLayer(3,false)##
		newEnemy.position = placeEnemyRelativeToPlr()
		add_child(newEnemy)
		newEnemy.disableCollision(false)
		for feature in paperEnemyFeatures :
			var newFeature = feature.instantiate()
			newEnemy.add_child(newFeature)
			
			if newFeature is Area2D :
				newFeature.set_collision_layer_value(4,false)##
				newFeature.set_collision_mask_value(4,false)##
				newFeature.set_collision_layer_value(8,true)##
				newFeature.set_collision_mask_value(8,true)##
				newFeature.set_collision_mask_value(5,true)
				newFeature.singleUse = false
			
		newEnemy.picture = paperEnemySprite
		if (rng.randf() < enemyIsBigChance) :
			print("spawned a big one")
			newEnemy.get_node("Helth").currentHealth = 1000
			newEnemy.get_node("MoveTowardPlayerBlind").defaultSpeed = 1.0
			newEnemy.get_node("Sprite2D").Scale = Vector2(3,3)
			newEnemy.get_node("CollisionShape2D").Scale = Vector2(3,3)
		await get_tree().create_timer(waitBetweenEnemySpawns).timeout
		

func timeLoop() :
	while true :
		for sets : Vector2 in sequence :
			#print(sets)
			waitBetweenEnemySpawns = sets.y
			await get_tree().create_timer(sets.x).timeout

func _ready() -> void:
	await get_tree().create_timer(initialGracePeriodLEngth).timeout
	periodical_table()
	timeLoop()
