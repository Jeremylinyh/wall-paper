extends Area2D

@export var miningSpeed : float = 10;
@export var output : int = 300

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	var bodies = get_overlapping_bodies()
	if (bodies.size() <= 0) :
		#print("not on ore")
		self.queue_free()
		return
	var oreNode = bodies[0]
	var helthNode : Node2D = $"..".get_node("Helth")
	while helthNode.currentHealth > (miningSpeed * 2) :
		await get_tree().create_timer(0.1).timeout
		helthNode.currentHealth -= miningSpeed
	
	get_parent().get_parent().get_parent().playerMaterial += output
	if oreNode :
		oreNode.queue_free()
	helthNode.currentHealth = 0
