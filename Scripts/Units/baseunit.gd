@tool
extends Node2D

@export var picture : Texture:
	get:
		return picture
	set(value) :
		picture = value
		if value == null or not value :
			return
		if not has_node("Sprite2D") :
			return
		$Sprite2D.texture = picture
		

func _ready() -> void:
	$Sprite2D.texture = picture

func disableCollision(disable : bool) :
	pass
	get_node("CollisionShape2D").disabled = disable
	
func setCollisionMask(number : int,boolean : bool) :
	$".".set_collision_mask_value(number,boolean)# .get_collider().set_collision_mask_value(number, boolean)
	
func setCollisionLayer(number : int,boolean : bool) :
	$".".set_collision_layer_value(number,boolean)
