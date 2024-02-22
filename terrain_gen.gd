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

const GRASS = Vector2i(0, 6)
const BLACKNESS = Vector2i(0, 12)

func gen_noise_map(frequency, octaves, lacunarity, gain, width, height):
	var noise_map = FastNoiseLite.new()
	var second_map = FastNoiseLite.new()
	
	second_map.seed = randi()
	second_map.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	second_map.frequency = frequency
	second_map.fractal_octaves = octaves
	second_map.fractal_lacunarity = lacunarity
	second_map.fractal_gain = gain
	
	noise_map.seed = randi()	
	noise_map.noise_type = FastNoiseLite.TYPE_PERLIN
	noise_map.frequency = frequency
	noise_map.fractal_octaves = octaves
	noise_map.fractal_lacunarity = lacunarity
	noise_map.fractal_gain = gain
	
	var grid = {}
	
	noise_map.frequency = 0.01
	
	for x in range(-width, width):
		var ground = abs(noise_map.get_noise_2d(x,0) * 60)
		for y in range(ground, height):
			var noise = min(noise_map.get_noise_2d(x,y), second_map.get_noise_2d(x,y))
			#var noise = abs(noise_map.get_noise_2d(x,y) * 2 - 1)
			grid[Vector2i(x,y)] = noise
			if noise > -0.25:
				tilemap.set_cell(0, Vector2i(x,y), 1, GRASS)
	return grid
	
func gen_normalized_terrain(width, height):
	for x in range(-width, width):
		for y in range(height):
			var pos = Vector2i(x, y)
			var alt = altitude_noise_layer[pos]
			
			if alt > -0.1: 
				tilemap.set_cell(0, pos, 1, GRASS)
			#elif alt > 0 and alt < 1.0:
			#	tilemap.set_cell(0, pos, 1, Vector2i(0,6))
			else:
				tilemap.set_cell(0, pos, 1, BLACKNESS)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	altitude_noise_layer = gen_noise_map(alt_freq, oct, lac, gain, map_width, map_height)
	#gen_normalized_terrain(map_width, map_height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
