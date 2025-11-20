extends RichTextLabel

@export var sceneRoot : Node2D

func _process(_delta: float) -> void:
	self.text = "Materials: " + str(sceneRoot.playerMaterial)
