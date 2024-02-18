extends Node2D

var noise_map
var altitude_noise_layer = {}

@export var map_width = 200
@export var map_height = 200

@export var alt_freq : float = 0.005
@export var oct : int = 5
@export var lac : int = 2
@export var gain : float = 0.5
@export var amplitude : float = 1.0

@onready var tilemap = $TileMap

@export var noise_height_text : NoiseTexture2D

func gen_noise_map(frequency, octaves, lacunarity, gain, width, height):
	var noise_map = FastNoiseLite.new()
	
	noise_map.seed = randi()	
	noise_map.noise_type = FastNoiseLite.TYPE_PERLIN
	noise_map.frequency = frequency
	noise_map.fractal_octaves = octaves
	noise_map.fractal_lacunarity = lacunarity
	noise_map.fractal_gain = gain
	
	var grid = {}
	
	noise_map.frequency = 0.01
	
	var maxbruh = 0
	var minbruh = 1203810293812
	for x in range(-width, width):
		for y in range(-height, height):
			var noise = noise_map.get_noise_2d(x,y)
			#var noise = abs(noise_map.get_noise_2d(x,y) * 2 - 1)
			grid[Vector2i(x,y)] = noise
			minbruh = min(noise, minbruh)
			maxbruh = max(noise, maxbruh)
	print(maxbruh)
	print(minbruh)
	return grid
	
func gen_normalized_terrain(width, height):
	for x in range(-width, width):
		for y in range(-height, height):
			var pos = Vector2i(x, y)
			var alt = altitude_noise_layer[pos]
			
			if alt < 0: 
				tilemap.set_cell(0, pos, 1, Vector2i(0,0))
			elif alt > 0 and alt < 1.0:
				tilemap.set_cell(0, pos, 1, Vector2i(0,6))
			else:  
				tilemap.set_cell(0, pos, 1, Vector2i(0,12))
	

# Called when the node enters the scene tree for the first time.
func _ready():
	altitude_noise_layer = gen_noise_map(alt_freq, oct, lac, gain, map_width, map_height)
	gen_normalized_terrain(map_width, map_height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
