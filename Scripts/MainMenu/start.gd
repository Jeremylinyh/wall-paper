extends Button

@export var loaderUI : TextureRect

func _on_pressed() -> void:
	loaderUI.visible = true
	loaderUI.modulate = Color.TRANSPARENT
	var tween = get_tree().create_tween()
	tween.tween_property(loaderUI, "modulate", Color.WHITE, 1.6)
	await get_tree().create_timer(1.6).timeout
	#loaderUI.visible = false
	#await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Scenes/map.tscn")
