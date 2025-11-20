extends Node2D

const chunkSize : float = 6
var executing : bool = false
const gridSize : float = 64

@export var oreSprite : PackedScene
var generatedChunks : Array[Vector2] = []
@export var genRadiusAroundPlr = 3

## selects picture for tile
@export var minableOre : Texture2D
@export var brownGrass : Texture2D
@export var greenGrass : Texture2D
func selectTile(height : float) :
	if height < 0.8 :
		return minableOre
	elif height < 0.0:
		return greenGrass
	else:
		return brownGrass

var noise = FastNoiseLite.new()
func _ready():
	# --- 1. Configure FastNoiseLite (Perlin Noise) ---
	# FastNoiseLite is the modern way to handle noise in Godot.
	# By default, FastNoiseLite uses TYPE_PERLIN, so no need to explicitly set it,
	# but we include it for clarity.
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	
	# Setting a seed ensures the noise pattern is the same every time.
	# You can change this to get different patterns.
	noise.seed = 1 #randi()
	
	# The frequency controls how zoomed in or out the noise is (how fast the values change).
	noise.frequency = 0.1
	
	# Octaves/Lacunarity/Gain control the layering (persistence) of noise, 
	# making it more detailed and natural-looking (Fractal Brownian Motion - FBM).
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.fractal_octaves = 1
	noise.fractal_lacunarity = 2.0
	noise.fractal_gain = 0.5
	

func fract(input : float) :
	var comp : int = floor(input)
	return input-comp

func random (st : Vector2) :
	return fract(sin((st.dot(Vector2(12.9898,78.233))))*43758.5453123);

## determine wether a spot has a ore
## input is expected to be normalized to chunk size
## yes.
func hasOre(at : Vector2) :
	at += Vector2(0.01,0.01)
	var oreScore : float = (random(at)/3.0)#-0.8
	var mustExceed : float = noise.get_noise_2d(at.x,at.y) # $NoiseGenerator.noise(at)# + 1.0
	#print(at,mustExceed,oreScore)
	return oreScore > mustExceed + 0.8 #or true

func generateChunk(chunkCoord : Vector2) :
	var gridSpaceCoord = chunkCoord * chunkSize
	for x in range(0,chunkSize,1) :
		for y in range(0,chunkSize,1)  :
			#print(x)
			var indicatedPos = Vector2(x,y) + gridSpaceCoord
			#print(indicatedPos)
			#var oreImage : Texture2D = selectTile( hasOre(indicatedPos) )
			if not hasOre(indicatedPos):
				continue
			var toPlacePos = indicatedPos * gridSize
			var toPlaced : Node2D = oreSprite.instantiate()
			
			#toPlaced.setImage(oreImage)
			
			add_child(toPlaced)
			toPlaced.position = toPlacePos

func evalPlr() :
	executing = true
	var plrPos : Vector2 = $"../Player".position
	plrPos = plrPos/gridSize
	plrPos = plrPos/chunkSize
	plrPos = round(plrPos)
	
	for xi in range(-genRadiusAroundPlr,genRadiusAroundPlr,1)  :
		for yi in range(-genRadiusAroundPlr,genRadiusAroundPlr,1) :
			var x = xi + plrPos.x
			var y = yi + plrPos.y
			if not generatedChunks.has(Vector2(x,y)) :
				generateChunk(Vector2(x,y))
				await get_tree().create_timer(0.0).timeout
				generatedChunks.append(Vector2(x,y))
				
				#print(x,y)
	await get_tree().create_timer(0.0).timeout
	executing = false
	#print(plrPos)

func _process(delta: float) -> void:
	if not executing :
		evalPlr()
	
