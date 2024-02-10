extends Node2D

@export var width = 10
@export var height = 10
@onready var tilemap = $TileMap

var fastNoiseLite = FastNoiseLite.new()

func initialize_2d_arr(width: int, height: int):
	var grid = []
	for i in width:
		grid.append([])
		for j in height:
			grid[i].append(0)
	return grid

func gen_noise_map(width: int, height: int):
	var noise_map = initialize_2d_arr(width, height)
	
	fastNoiseLite.frequency = 0.01
	
	for x in range(width):
		for y in range(height):
			var noise = 0.0
			noise = fastNoiseLite.get_noise_2d(x,y)
			noise_map[x][y] = noise
	print(noise_map)
	return noise_map
	

func normalize_terrain():
	pass
	

# Called when the node enters the scene tree for the first time.
func _ready():
	fastNoiseLite.seed = randi()
	fastNoiseLite.noise_type = FastNoiseLite.TYPE_PERLIN
	
	gen_noise_map(width, height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
