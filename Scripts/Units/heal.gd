extends Node2D

@export var maxHealPerUnit : int = 100
@export var healUnit : int = 6
@export var healTime : float = 3.0

func _ready() -> void:
	$"../Helth".totalHealth = maxHealPerUnit
	while (true) :
		await get_tree().create_timer(healTime/healUnit).timeout
		$"../Helth".currentHealth -= healUnit * 1.6
		var bodies : Array[Node2D] = $Area2D.get_overlapping_bodies()
		for body in bodies :
			print(body.has_node("Healer"))
			if body.has_node("Helth") and (not body.has_node("Healer")) :
				var health : Node2D = body.get_node("Helth")
				health.currentHealth += healUnit
			
