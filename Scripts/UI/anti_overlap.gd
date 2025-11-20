extends Panel

var _occupied_positions : Array[Vector2] = []

func addOccupiedPosition(pos : Vector2):
	_occupied_positions.append(pos)

func checkIfPositionInvalid(pos : Vector2) :
	return _occupied_positions.has(pos)

func disOccupy(pos : Vector2) :
	var index : int = _occupied_positions.find(pos)
	#print(index)
	if index == -1 :
		return
	_occupied_positions.remove_at(index)
