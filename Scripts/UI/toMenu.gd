extends Button

var changing : bool = false
@export var loadingScreen : TextureRect

func _on_pressed() -> void:
	if changing :
		return
	changing = true
	
	Engine.time_scale = 1
	loadingScreen.visible = true
	#loadingScreen.modulate = Color.TRANSPARENT
	#var tween = get_tree().create_tween()
	#tween.tween_property(loadingScreen, "modulate", Color.WHITE, 1.6)
	#await get_tree().create_timer(1.6).timeout
	
	get_tree().change_scene_to_file("res://Scenes/MainMenu/menu_screen.tscn")
