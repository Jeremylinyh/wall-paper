extends RichTextLabel

@export var funniPhrases : Array[String]

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	text = funniPhrases[rng.randi_range(0,funniPhrases.size()-1)]
