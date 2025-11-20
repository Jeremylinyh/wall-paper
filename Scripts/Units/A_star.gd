extends Node2D
# A* Pathfinding implementation for a grid-based search in Godot.
# This script maintains strict separation of concerns, ensuring each function
# performs only one operation.

class_name Pathfinder

# ==============================================================================
# 1. CORE PATHFINDING FUNCTION (The Coordinator)
# ==============================================================================

# Function: find_path
# --------------------
# Main function that coordinates the A* search.
# Inputs: start_pos (Vector2), end_pos (Vector2)
# Returns: Array[Vector2] (the path, excluding start_pos)
func find_path(start_pos: Vector2, end_pos: Vector2) -> Array:
	# Initial validation
	if start_pos == end_pos or not can_traverse(start_pos) or not can_traverse(end_pos):
		return []

	# 1. Initialize data structures
	var data: Dictionary = _initialize_data(start_pos, end_pos)
	var open_set: Array = data.open_set
	var came_from: Dictionary = data.came_from
	var g_score: Dictionary = data.g_score
	var f_score: Dictionary = data.f_score
	var directions: Array = _get_neighbor_directions()

	# 2. A* Core Loop
	while not open_set.is_empty():
		await get_tree().create_timer(0.0).timeout
		var current_pos: Vector2 = _find_best_node(open_set, f_score)

		# Path Found
		if current_pos == end_pos:
			return _reconstruct_path(came_from, current_pos)

		_remove_from_open_set(open_set, current_pos)

		# Process all neighbors using mathematical directions
		for direction in directions:
			var neighbor_pos: Vector2 = current_pos + direction
			
			_evaluate_neighbor(current_pos, neighbor_pos, end_pos, came_from, g_score, f_score, open_set)
	
	# Target was not reached (no path exists)
	return []

# ==============================================================================
# 2. INITIALIZATION AND UTILITY FUNCTIONS
# ==============================================================================

# Function: _initialize_data
# --------------------------
# Creates the initial dictionaries and array required for the search.
func _initialize_data(start_pos: Vector2, end_pos: Vector2) -> Dictionary:
	var g_score: Dictionary = {start_pos: 0.0}
	var f_score: Dictionary = {start_pos: _calculate_heuristic(start_pos, end_pos)}
	
	return {
		"open_set": [start_pos],
		"came_from": {},
		"g_score": g_score,
		"f_score": f_score
	}

# Function: _get_neighbor_directions
# ----------------------------------
# Returns the 8 standard Vector2 offsets for grid movement.
func _get_neighbor_directions() -> Array[Vector2]:
	# Cardinal (straight) and Diagonal offsets
	return [
		Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0),
		Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)
	]

# Function: _remove_from_open_set
# -------------------------------
# Removes a node from the open list after it has been selected for processing.
func _remove_from_open_set(open_set: Array, pos: Vector2) -> void:
	open_set.erase(pos)

# Function: _find_best_node
# -------------------------
# Finds and returns the node in the open_set with the lowest F score.
func _find_best_node(open_set: Array, f_score: Dictionary) -> Vector2:
	var best_pos: Vector2 = open_set[0]
	var min_f_score: float = f_score.get(best_pos, INF)
	
	for pos in open_set:
		var pos_f_score: float = f_score.get(pos, INF)
		if pos_f_score < min_f_score:
			min_f_score = pos_f_score
			best_pos = pos
			
	return best_pos

# ==============================================================================
# 3. COST & NEIGHBOR EVALUATION FUNCTIONS
# ==============================================================================

# Function: _calculate_movement_cost
# ----------------------------------
# Calculates the G cost between two adjacent grid nodes.
func _calculate_movement_cost(pos_a: Vector2, pos_b: Vector2) -> float:
	var dx: float = abs(pos_a.x - pos_b.x)
	var dy: float = abs(pos_a.y - pos_b.y)
	
	# 1.41421356 is the square root of 2 (diagonal movement cost)
	if dx == 1.0 and dy == 1.0:
		return 1.41421356 
	# 1.0 is cardinal movement cost
	elif dx == 1.0 or dy == 1.0:
		return 1.0      
	
	return 0.0

# Function: _calculate_heuristic
# ------------------------------
# Calculates the H cost (estimated cost to target) using Euclidean distance.
func _calculate_heuristic(pos: Vector2, end_pos: Vector2) -> float:
	return pos.distance_to(end_pos)

# Function: _evaluate_neighbor
# ----------------------------
# Determines if the current path to the neighbor is an improvement and updates scores.
func _evaluate_neighbor(current_pos: Vector2, neighbor_pos: Vector2, end_pos: Vector2, 
					   came_from: Dictionary, g_score: Dictionary, f_score: Dictionary, open_set: Array) -> void:
	
	# Check if the neighbor can be traversed (uses user-defined function)
	if not can_traverse(neighbor_pos):
		return
	
	var tentative_g_score: float = g_score.get(current_pos, INF) + _calculate_movement_cost(current_pos, neighbor_pos)
	
	# If the tentative G score is not better than the current best G score for the neighbor, stop.
	if tentative_g_score >= g_score.get(neighbor_pos, INF):
		return
		
	# New path is better: record, update scores, and ensure node is in open set
	_update_path_data(current_pos, neighbor_pos, tentative_g_score, end_pos, came_from, g_score, f_score, open_set)

# Function: _update_path_data
# ---------------------------
# Updates the path parent, G score, and F score, and adds the node to the open set if new.
func _update_path_data(parent_pos: Vector2, child_pos: Vector2, new_g_score: float, end_pos: Vector2,
					   came_from: Dictionary, g_score: Dictionary, f_score: Dictionary, open_set: Array) -> void:
	
	came_from[child_pos] = parent_pos
	g_score[child_pos] = new_g_score
	
	var h_score: float = _calculate_heuristic(child_pos, end_pos)
	f_score[child_pos] = new_g_score + h_score
	
	if not child_pos in open_set:
		open_set.append(child_pos)

# ==============================================================================
# 4. PATH RECONSTRUCTION & USER HOOK
# ==============================================================================

# Function: _reconstruct_path
# ---------------------------
# Builds the final path array by backtracking from the target node to the start node.
func _reconstruct_path(came_from: Dictionary, current: Vector2) -> Array:
	var path_list: Array = [current]
	var temp_current: Vector2 = current
	
	# Backtrack until the start node (which has no predecessor in came_from)
	while came_from.has(temp_current):
		temp_current = came_from[temp_current]
		path_list.append(temp_current)
		
	path_list.reverse()
	
	# Remove the start position
	if path_list.size() > 0:
		path_list.remove_at(0) 
		
	return path_list

# --- REQUIRED USER-DEFINED FUNCTION (Placeholder Example) ---
# This function is crucial for defining the "occupied" status of the infinite grid.
# You must implement the logic to check your grid structure (e.g., TileMap or world boundaries).
func can_traverse(pos: Vector2) -> bool:
		
	return true
