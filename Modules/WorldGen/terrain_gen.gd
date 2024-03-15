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
@export var ore_offset : int = 10

@onready var tilemap = $TileMap

const ABOVE_GROUND = -10
const GRASS_LEVEL = -20
const BLANK = -30

const FOREGROUND = 1
const BACKGROUND = 0

const GRASS = Vector2i(0,0)
const GRASS_TOP = Vector2i(2,0)
const STONE = Vector2i(0,1)
const BLACKNESS = Vector2i(0,6)
const RED = Vector2i(24,12)

const DECOR_GRASS_1 = Vector2i(1,4)
const DECOR_GRASS_2 = Vector2i(1,6)

const DECOR_TREE_1 = Vector2i(2,6)
const DECOR_TREE_1_TOP = Vector2i(2,5)
const DECOR_TREE_2 = Vector2i(3,6)
const DECOR_TREE_2_TOP = Vector2i(3,5)

const DECOR_BIG_TREE = Vector2i(3,4)
const DECOR_BIG_TREE_TOP_1 = Vector2i(3,3)
const DECOR_BIG_TREE_TOP_2 = Vector2i(3,2)
				
func gen_surface(forward):
	var last_height = 0
	var next_move = 0
	var section_width = 0
	
	var r = range(0, map_width+1)
	
	if not forward:
		r = range(0, -map_width-1, -1)
	
	for x in r:
		if forward and x < 0:
			continue
		var min_section_width = randi() % 10 + 4 
		next_move = randi() % 2
		
		if next_move == 0 and section_width > min_section_width:
			last_height -= 1
			section_width = 0
		elif next_move == 1 and section_width > min_section_width:
			last_height += 1
			section_width = 0
			
		section_width += 1
		
		for y in range(last_height, map_height):
			var pos = Vector2i(x, y) 
			tilemap.set_cell(FOREGROUND, Vector2i(x, y), 0, GRASS)
			if y > last_height + cave_biome_change:
				tilemap.set_cell(FOREGROUND, pos, 0, STONE)
			elif y > last_height + cave_biome_change * 2:
				tilemap.set_cell(FOREGROUND, pos, 0, Vector2i(0,3))
			elif y > last_height + cave_biome_change * 3:
				tilemap.set_cell(FOREGROUND, pos, 0, Vector2i(0,5))
			else:
				noise_grid[pos] = GRASS_LEVEL 
		ground_levels[x] = last_height
			
func gen_new_noise(noise_type, freq, oct, lac, g):
	var fnl = FastNoiseLite.new()
	fnl.seed = randi()
	fnl.noise_type = noise_type
	fnl.frequency = freq
	fnl.fractal_octaves = oct
	fnl.fractal_lacunarity = lac
	fnl.fractal_gain = g
	return fnl
	
func gen_caves():
	var cave_noise = gen_new_noise(FastNoiseLite.TYPE_PERLIN, frequency * 7, octaves, lacunarity, gain)
	var secondary_noise = gen_new_noise(FastNoiseLite.TYPE_SIMPLEX_SMOOTH, frequency * 16, octaves, lacunarity, gain) 
	for x in range(-map_width, map_width):	
		for y in range(ground_levels[x] + cave_offset, map_height):
			if x in range(-10, 10) && y in range(-10, 10):
				continue
			if cave_noise.get_noise_2d(x,y) < noise_threshold:
				if secondary_noise.get_noise_2d(x,y) < 0.25:
					tilemap.set_cell(1, Vector2i(x,y), -1) #, BLACKNESS)
					noise_grid[Vector2i(x,y)] = BLANK

func gen_grass():
	for i in range(-map_width, map_width):
		var ground = ground_levels[i]
		var pos = Vector2i(i, ground)
		if noise_grid[pos] == GRASS_LEVEL:
			tilemap.set_cell(FOREGROUND, pos, 0, GRASS_TOP)
			
func gen_plants():
	for i in range(-map_width, map_width):
		var rand = randi() % 100
		if rand < 50:
			gen_decor_grass(i)
		elif rand < 70:
			gen_decor_tree(i)
			
func gen_decor_grass(col):
	var rand = randi() % 2
	var dec = DECOR_GRASS_1
	if rand == 0:
		dec = DECOR_GRASS_2
	if noise_grid[Vector2i(col, ground_levels[col])] != BLANK:
		tilemap.set_cell(BACKGROUND, Vector2i(col, ground_levels[col] - 1), 0, dec)
		
func gen_decor_tree(col):
	if noise_grid[Vector2i(col, ground_levels[col])] == BLANK:
		return
	var height = randi() % 10 + 1
	var rand = randi() % 3
	var dec 	
	if rand == 0:
		dec = DECOR_TREE_1
		tilemap.set_cell(BACKGROUND, Vector2i(col, -height), 0, DECOR_TREE_1_TOP)
	elif rand == 1:
		dec = DECOR_TREE_2
		tilemap.set_cell(BACKGROUND, Vector2i(col, -height), 0, DECOR_TREE_2_TOP)
	elif rand == 2:
		dec = DECOR_BIG_TREE
		tilemap.set_cell(BACKGROUND, Vector2i(col, -height), 0, DECOR_BIG_TREE_TOP_1)
		tilemap.set_cell(BACKGROUND, Vector2i(col, -height-1), 0, DECOR_BIG_TREE_TOP_2)
	for h in range(ground_levels[col]-1, -height, -1):
		tilemap.set_cell(BACKGROUND, Vector2i(col, h), 0, dec)
	

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
		for y in range(ground_levels[x] + ore_offset + 1, map_height):
			if ore_noise.get_noise_2d(x,y) < ore_rarity:
				tilemap.set_cell(FOREGROUND, Vector2i(x,y), 0, Vector2i(2,1))

func gen_walls():
	for x in range(-map_width, map_width):
		for y in range(ground_levels[x] + 1, map_height):
			if y > ground_levels[x] + 1 or noise_grid[Vector2i(x, ground_levels[x])] == GRASS_LEVEL:
				tilemap.set_cell(BACKGROUND, Vector2i(x,y), 0, BLACKNESS)

# Called when the node enters the scene tree for the first time.
func _ready():
	#noise_grid = gen_noise_map()
	gen_surface(true)
	gen_surface(false)
	gen_ore()
	gen_caves()
	gen_spawn_area()
	gen_grass()
	gen_plants()
	gen_walls()
	
	tilemap.set_cell(FOREGROUND, Vector2i(0,0), 1, Vector2i(2,6))
	#gen_normalized_terrain(map_width, map_height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
