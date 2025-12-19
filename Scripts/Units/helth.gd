extends Node2D

@export var totalHealth : float = 100
@export var currentHealth : float = 100 : 
	get:
		return currentHealth
	set(value) :
		var helthPercent : float = value/totalHealth
		$Total/Percentage.set_scale(Vector2(max(helthPercent,0),1))
		currentHealth = min(value,totalHealth)
		if value <= 0 :
			if get_parent().name == "Player" :
				get_parent().kill()
			else :
				get_parent().queue_free()
