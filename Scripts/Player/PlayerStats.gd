extends Node2D

@export var Health : int = 100

func getPosition() :
	return $CharacterBody2D.position
	
func _ready() -> void:
	for children in self.get_children() :
		$CharacterBody2D.add_child(children)
