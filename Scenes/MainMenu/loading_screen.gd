extends TextureRect

func _ready() -> void:
	self.z_index = 4095
	visible = true
	await get_tree().create_timer(0.6).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1.6)
	self.z_index = -4095
	await get_tree().create_timer(1.6).timeout
	self.queue_free()
	
