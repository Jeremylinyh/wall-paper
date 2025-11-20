extends Node2D

func _ready() -> void:
	print("SOF")
	var path : Array = $"../AI slop".find_path(Vector2(1,1),Vector2(3,9))
	#print(path)
	for waypoint in path :
		print(waypoint)
		print(typeof(waypoint))
	print("EOF")
