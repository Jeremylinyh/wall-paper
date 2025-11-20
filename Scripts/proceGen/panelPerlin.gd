extends Panel

func _process(delta: float) -> void:
	print(get_global_transform().origin)
