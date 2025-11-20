extends Node2D

func _round_Vector_2(inVec : Vector2) : 
	return Vector2(roundf(inVec.x),roundf(inVec.y))

func _input(event: InputEvent) -> void:
	var mouseCurrPos : Vector2
	if event is InputEventMouseMotion:
		mouseCurrPos = (event.position)
	else :
		return
		
	# now we need to snap to the grid of 64x64
	mouseCurrPos = (mouseCurrPos + Vector2(32,32))/ 64
	mouseCurrPos = _round_Vector_2(mouseCurrPos)*64
	#print(mouseCurrPos)
