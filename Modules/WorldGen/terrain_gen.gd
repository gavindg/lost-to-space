extends Node2D

var noise_gen
var ground_levels = {}
var noise_grid = {}
var spawn_location

@export var map_width = 200
@export var map_height = 200

@export var frequency : float = 0.005
@export var octaves : int = 5
@export var lacunarity : int = 2
@export var gain : float = 0.5
@export var noise_threshold : float = -0.25
@export var cave_offset : int = 50
@export var cave_biome_change : int = 20
@export var ore_rarity : float = -0.2

@onready var tilemap = $TileMap

const ABOVE_GROUND = -10
const GRASS_LEVEL = -20

const FOREGROUND = 1
const BACKGROUND = 0

const GRASS = Vector2i(0,0)
const GRASS_TOP = Vector2i(2,0)
const STONE = Vector2i(0,1)
const BLACKNESS = Vector2i(0,6)
const RED = Vector2i(24,12)

func gen_new_noise(noise_type, freq, oct, lac, g):
	var fnl = FastNoiseLite.new()
	fnl.seed = randi()
	fnl.noise_type = noise_type
	fnl.frequency = freq
	fnl.fractal_octaves = oct
	fnl.fractal_lacunarity = lac
	fnl.fractal_gain = g
	return fnl

func gen_noise_map():
	var primary_noise = gen_new_noise(FastNoiseLite.TYPE_PERLIN, frequency, octaves, lacunarity, gain)
	#var second_noise = gen_new_noise(FastNoiseLite.TYPE_SIMPLEX_SMOOTH, frequency, octaves, lacunarity, gain)
	
	var grid = {}
	
	# Loops through the sizes of the level, generates noise, and sets it to the noise_grid
	for x in range(-map_width, map_width):
		var ground_level = abs(primary_noise.get_noise_2d(x,0) * 60)
		ground_levels[x] = ground_level
		for y in range(0, map_height):
			var pos = Vector2i(x,y)
			if y < ground_level:
				#tilemap.set_cell(0, pos, 1, RED)
				grid[pos] = ABOVE_GROUND
				continue
			#var noise = primary_noise.get_noise_2d(x,y)
			#var noise = min(primary_noise.get_noise_2d(x,y), second_noise.get_noise_2d(x,y)) # Take the minimum of two noises	
			tilemap.set_cell(FOREGROUND, pos, 0, GRASS)
			if y > ground_level + cave_biome_change:
				tilemap.set_cell(FOREGROUND, pos, 0, STONE)
			elif y > ground_level + cave_biome_change * 2:
				tilemap.set_cell(FOREGROUND, pos, 0, Vector2i(0,3))
			elif y > ground_level + cave_biome_change * 3:
				tilemap.set_cell(FOREGROUND, pos, 0, Vector2i(0,5))
			else: 
				grid[pos] = GRASS_LEVEL
	return grid	
	
func gen_caves():
	var cave_noise = gen_new_noise(FastNoiseLite.TYPE_PERLIN, frequency * 5, octaves, lacunarity, gain)
	var secondary_noise = gen_new_noise(FastNoiseLite.TYPE_SIMPLEX_SMOOTH, frequency * 10, octaves, lacunarity, gain) 
	for x in range(-map_width, map_width):
		for y in range(ground_levels[x] + cave_offset + 1, map_height):
			if cave_noise.get_noise_2d(x,y) < noise_threshold:
				if secondary_noise.get_noise_2d(x,y) < 0.35:
					tilemap.set_cell(1, Vector2i(x,y), -1) #, BLACKNESS)
					noise_grid[Vector2i(x,y)] = 12390

func gen_grass():
	for i in range(-map_width, map_width):
		var ground = ground_levels[i] + 1
		var pos = Vector2i(i, ground)
		if noise_grid[pos] == GRASS_LEVEL:
			tilemap.set_cell(FOREGROUND, pos, 0, GRASS_TOP)

func gen_spawn_area():
	var sel 
	for i in range(0, map_width):
		var ground = ground_levels[i]
		var pos = Vector2i(i, ground)
		if noise_grid[pos] == GRASS_LEVEL: # if there is grass here
			sel = Vector2i(pos)
			break
	spawn_location = sel

func gen_ore():
	var ore_noise = gen_new_noise(FastNoiseLite.TYPE_PERLIN, frequency * 25, octaves, lacunarity, gain)
	for x in range(-map_width, map_width):
		for y in range(ground_levels[x] + cave_offset +1, map_height):
			if ore_noise.get_noise_2d(x,y) < ore_rarity:
				tilemap.set_cell(FOREGROUND, Vector2i(x,y), 0, Vector2i(2,1))

func gen_walls():
	for x in range(-map_width, map_width):
		for y in range(ground_levels[x] + 1, map_height):
			tilemap.set_cell(BACKGROUND, Vector2i(x,y), 0, BLACKNESS)

# Called when the node enters the scene tree for the first time.
func _ready():
	noise_grid = gen_noise_map()

	gen_ore()
	gen_caves()
	gen_spawn_area()
	gen_grass()
	gen_walls()
	
	tilemap.set_cell(FOREGROUND, Vector2i(0,0), 1, Vector2i(2,6))
	#gen_normalized_terrain(map_width, map_height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
