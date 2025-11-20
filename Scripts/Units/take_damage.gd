extends Node2D

@export var singleUse : bool = true

var lastUsed : float = 0
#var inPlayer : bool = false
var currentBody : CharacterBody2D = null

func _process(delta: float) -> void:
	#print(lastUsed)
	if currentBody :
		if (Time.get_ticks_msec() - lastUsed) < 360.0 :
			return
		lastUsed = Time.get_ticks_msec()
		
		if (currentBody.has_node("Helth")) :
			var helthNode : Node2D = currentBody.get_node("Helth")
			helthNode.currentHealth -= 10
			if singleUse :
				get_parent().queue_free()
		else:
			currentBody = null

func _on_body_entered(body: CharacterBody2D) -> void:
	if (body == get_parent()):
		return
	if (body == get_parent().get_child(1)):
		return
	if (not (body is CharacterBody2D)):
		return
	#print(get_parent())
	#get_parent().queue_free()
	#inPlayer = true
	currentBody = body
	
	if (body.has_node("Helth")) :
		var helthNode : Node2D = body.get_node("Helth")
		helthNode.currentHealth -= 10
		if singleUse :
			get_parent().queue_free()
		#lastUsed = get_ticks_msec()


func _on_body_exited(body: Node2D) -> void:
	currentBody = null
	#inPlayer = false

func setCollisionMask(number : int,boolean : bool) :
	$".".set_collision_mask_value(number,boolean)# .get_collider().set_collision_mask_value(number, boolean)
	
func setCollisionLayer(number : int,boolean : bool) :
	$".".set_collision_layer_value(number,boolean)
