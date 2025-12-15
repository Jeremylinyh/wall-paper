extends Node2D

@export var maxHealPerUnit : int = 100
@export var healUnit : int = 6
@export var healTime : float = 3.0

func _ready() -> void:
	$"../Helth".totalHealth = maxHealPerUnit
	while (true) :
		await get_tree().create_timer(healTime/healUnit).timeout
		$"../Helth".currentHealth -= healUnit
		var bodies : Array[Node2D] = $Area2D.get_overlapping_bodies()
		for body in bodies :
			print(body)
			if body.has_node("Helth") :
				var health : Node2D = body.get_node("Helth")
				health.currentHealth -= 10
			
