extends Node2D

@export var projectile : PackedScene
@export var waitBetweenEachShot : float = 1.67
@export var Enabled : bool = true

@export var Mob_spawner : Node2D
@export var parentTo : Node2D
@export var projectileSpeed : float = 300
@export var projectilePicture : Texture
@export var projectleLifetime : float = waitBetweenEachShot / 3.

@export var mustContain : Array[PackedScene]

var rng = RandomNumberGenerator.new()

const determineClosestMaxTries : int = 10
## The tries parameter will determine the maximum number it searcehes
func _getClosestEnemy(tries : int = determineClosestMaxTries) :
	var counter : int = 1
	var closestEnemy : CharacterBody2D = null
	var closestDistance : float = INF
	
	var numberOfChildren : int = Mob_spawner.get_child_count()
	if numberOfChildren <= 0:
		return null
	var randomNumber : int = rng.randi_range(0,numberOfChildren-1)
	return Mob_spawner.get_child(randomNumber)
	#for enemy : CharacterBody2D in Mob_spawner.get_children() :
		#counter += 1
		##print(enemy)
		#var distanceToEnemy : float = (enemy.position - position).length()
		#if distanceToEnemy < closestDistance:
			#closestDistance = distanceToEnemy
			#closestEnemy = enemy
		#if counter > tries :
			#break
	#return closestEnemy

func _shootingLoop() :
	var closestEnemy = _getClosestEnemy(determineClosestMaxTries)
	if not closestEnemy :
		#print("no enemy found!")
		return
	var newProjectile : CharacterBody2D = projectile.instantiate()
	parentTo.add_child(newProjectile)
	newProjectile.setCollisionLayer(3,false)##
	newProjectile.velocity = (closestEnemy.position-get_parent().position).normalized() * projectileSpeed
	newProjectile.position = get_parent().position
	newProjectile.picture = projectilePicture
	for feature in mustContain:
		newProjectile.add_child(feature.instantiate())
	#newProjectile.move_and_slide()
	await get_tree().create_timer(projectleLifetime).timeout
	if newProjectile :
		newProjectile.queue_free()
	
	#print("projectile lifetime complete")

func _process(delta: float) -> void:
	#lag inducer
	for projectile : CharacterBody2D in parentTo.get_children() :
		projectile.move_and_collide(projectile.velocity * delta)
		projectile.move_and_slide()

func _ready() -> void:
	#print("shooting enemies!")
	while (true) :
		await get_tree().create_timer(waitBetweenEachShot).timeout
		if Enabled :
			_shootingLoop()
