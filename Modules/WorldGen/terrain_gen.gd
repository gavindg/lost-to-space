extends Node2D

@onready var tilemap = $TileMap

# MAP DIMENSIONS!!!

## The map generated width
@export var map_width : int = 200
## The map generated height
@export var map_height : int = 200

# NOISE SETTINGS!!!

## The base frequency, likely do not change
@export var frequency : float = 0.005
## The number of octaves in the perlin noise, essentially levels of detail
@export var octaves : int = 3
## The lacunarity determines how much detail is added/removed at each octave (affects frequency) (DO NOT CHANGE = 2)
@export var lacunarity : int = 2
## The gain affects the amplitude of each octave (DO NOT CHANGE = 0.5)
@export var gain : float = 0.5

# NOISE THRESHOLDS!!!

@export var cave_lower_threshold : float = 0.05
@export var cave_upper_threshold : float = 0.15
@export var ore_lower_threshold : float = 0.3

# FREQUENCY VARIABLES!!!

## Multiply these with the base frequency to get a new freq
@export var cave_freq_mult : float = 4
@export var ore_freq_mult : float = 25

## By percentage
@export var grass_rarity : float = 40 
@export var tree_rarity : float = 15


# MISC VARIABLES!!!

## How many tiles do caves start
@export var cave_offset : int = 0
## The amount of tiles in which the biome changes
@export var cave_biome_change : int = 20
## How many tiles until ores start spawning
@export var ore_offset : int = 10
## Minimum width a patch of the surface has to be flat for
@export var min_flat_width : int = 10
## Source id for the main tileset
@export var source_id : int = 0
## Max and min height of the tree
@export var min_tree_height : int = 1
@export var max_tree_height : int = 10

const GRASS_LEVEL = -20
const BLANK = -30

# LAYERS!!!
const FOREGROUND = 1
const BACKGROUND = 0

# SPRITES!!!
const SPRITE_DIRT = Vector2i(0, 0)
const SPRITE_DIRT_TOP = Vector2i(2, 0)
const SPRITE_STONE = Vector2i(0, 1)
const SPRITE_ORE1 = Vector2i(2,1)

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

## Maps x-values to where their ground is supposed to be
var ground_levels = {}
var noise_grid = {}

## Maps Vector2is to certain values that represent tiles in the foreground, background
var fg_tile_matrix = {}
var bg_tile_matrix = {}

var spawn_location

## Generates a new FastNoiseLite object given a noise type, frequency, octaves, lacunarity, and gain. 
func gen_new_noise(noise_type, freq = frequency, oct = octaves, lac = lacunarity, g = gain):
	var fnl = FastNoiseLite.new()
	fnl.seed = randi()
	fnl.noise_type = noise_type
	fnl.frequency = freq
	fnl.fractal_octaves = oct
	fnl.fractal_lacunarity = lac
	fnl.fractal_gain = g
	return fnl

## Generates the surface smoothly by using a walk (either go up one or down one or stay the same).
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
		var min_section_width = randi() % 10 + min_flat_width
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
			fg_tile_matrix[pos] = 'DIRT'
			#tilemap.set_cell(FOREGROUND, pos, 0, GRASS)
			if y > last_height + cave_biome_change:
				fg_tile_matrix[pos] = 'STONE'
				#tilemap.set_cell(FOREGROUND, pos, 0, STONE)
			#elif y > last_height + cave_biome_change * 2:
				#tilemap.set_cell(FOREGROUND, pos, 0, Vector2i(0,3))
			#elif y > last_height + cave_biome_change * 3:
				#tilemap.set_cell(FOREGROUND, pos, 0, Vector2i(0,5))
			elif y == last_height:
				fg_tile_matrix[pos] = 'DIRT_TOP'
				noise_grid[pos] = GRASS_LEVEL
		ground_levels[x] = last_height

## Generates caves using "perlin worms." 
func gen_caves():
	var cave_noise = gen_new_noise(FastNoiseLite.TYPE_PERLIN, frequency * cave_freq_mult)
	for x in range(-map_width, map_width): 
		for y in range(map_height, ground_levels[x]-1, -1):
		#for y in range(ground_levels[x]+cave_offset, map_height):
			# Range where we don't want caves
			if x in range(-30, 30) && y in range(-15, 15):
				continue
			if y == ground_levels[x] and fg_tile_matrix[Vector2i(x, y+1)] != 'CAVE':
				continue
			var normalized = abs(cave_noise.get_noise_2d(x, y))
			var pos = Vector2i(x, y)
			if cave_lower_threshold < normalized && normalized < cave_upper_threshold:
				#tilemap.set_cell(1, Vector2i(x, y), -1)
				fg_tile_matrix[pos] = 'CAVE'
			if y == ground_levels[x]:
				noise_grid[pos] = BLANK
	
## Old way of generating caves, using a noise threshold and then generating little platforms using a secondary simplex noise.
#func gen_caves_old():
	#var cave_noise = gen_new_noise(FastNoiseLite.TYPE_PERLIN, frequency * 7, octaves, lacunarity, gain)
	#var secondary_noise = gen_new_noise(FastNoiseLite.TYPE_SIMPLEX_SMOOTH, frequency * 16, octaves, lacunarity, gain) 
	#for x in range(-map_width, map_width):	
		#for y in range(ground_levels[x] + cave_offset, map_height):
			#if x in range(-10, 10) && y in range(-10, 10):
				#continue
			#if cave_noise.get_noise_2d(x,y) < cave_threshold:
				#if secondary_noise.get_noise_2d(x,y) < -cave_threshold:
					#tilemap.set_cell(1, Vector2i(x,y), -1) #, BLACKNESS)
					#noise_grid[Vector2i(x,y)] = BLANK

## Replaces top layer tiles with grass. Will be obsolete once autotiling is implemented.
func gen_grass():
	for i in range(-map_width, map_width):
		var ground = ground_levels[i]
		var pos = Vector2i(i, ground)
		if noise_grid[pos] == GRASS_LEVEL:
			tilemap.set_cell(FOREGROUND, pos, 0, GRASS_TOP)

## Generates plants as decoration. Randomly chooses whether to place grass, place a tree, or place nothing.
func gen_plants():
	for i in range(-map_width, map_width):
		var rand = randi() % 100
		if rand < grass_rarity:
			gen_decor_grass(i)
		elif rand < grass_rarity + tree_rarity:
			gen_decor_tree(i)

## Generates one of the grass sprites as a background on the surface.
func gen_decor_grass(col):
	var rand = randi() % 2
	var dec = DECOR_GRASS_1
	if rand == 0:
		dec = DECOR_GRASS_2
	if noise_grid[Vector2i(col, ground_levels[col])] != BLANK:
		tilemap.set_cell(BACKGROUND, Vector2i(col, ground_levels[col] - 1), 0, dec)

## Generates a random height for the tree and then chooses a random sprite to do it with. Have to rewrite this anyways so no refactoring
func gen_decor_tree(col):
	if noise_grid[Vector2i(col, ground_levels[col])] == BLANK:
		return
	var ground = ground_levels[col]
	var height = randi() % max_tree_height + min_tree_height
	var rand = randi() % 3
	var dec     
	if rand == 0:
		dec = DECOR_TREE_1
		tilemap.set_cell(BACKGROUND, Vector2i(col, ground-1), 0, DECOR_TREE_1)
		tilemap.set_cell(BACKGROUND, Vector2i(col, ground-2), 0, DECOR_TREE_1_TOP)
		return
	elif rand == 1:
		dec = DECOR_TREE_2
		tilemap.set_cell(BACKGROUND, Vector2i(col, ground-height), 0, DECOR_TREE_2_TOP)
	elif rand == 2:
		dec = DECOR_BIG_TREE
		tilemap.set_cell(BACKGROUND, Vector2i(col, ground-height), 0, DECOR_BIG_TREE_TOP_1)
		tilemap.set_cell(BACKGROUND, Vector2i(col, ground-height-1), 0, DECOR_BIG_TREE_TOP_2)
	for h in range(ground-1, ground-height, -1):
		tilemap.set_cell(BACKGROUND, Vector2i(col, h), 0, dec)


#func gen_spawn_area():
	#var sel 
	#
	#for i in range(0, map_width):
		#var ground = ground_levels[i]
		#var pos = Vector2i(i, ground)
		#if noise_grid[pos] == GRASS_LEVEL: # if there is grass here
			#sel = Vector2i(pos)
			#break
	#spawn_location = sel

## Generates the ore using a new perlin noise. 
func gen_ore():
	var ore_noise = gen_new_noise(FastNoiseLite.TYPE_PERLIN, frequency * ore_freq_mult, octaves, lacunarity, gain)
	for x in range(-map_width, map_width):
		for y in range(ground_levels[x] + ore_offset + 1, map_height):
			if ore_noise.get_noise_2d(x,y) > ore_lower_threshold:
				fg_tile_matrix[Vector2i(x,y)] = 'ORE1'

## Generates walls everywhere except for the first layer of grass (and in the air). Will probably be replaced.
func gen_walls():
	for x in range(-map_width, map_width):
		for y in range(ground_levels[x], map_height):
			if y > ground_levels[x] or noise_grid[Vector2i(x, ground_levels[x])] == GRASS_LEVEL:
				tilemap.set_cell(BACKGROUND, Vector2i(x,y), 0, BLACKNESS)

## Generates cloned sides for an attempt at wrapping the tilemap.
func gen_cloned_sides():
	for x in range(-map_width, -map_width+50):
		for y in range(-100, map_height):
			var og_right = Vector2i(x, y)
			var og_left = Vector2i(x + 2 * map_width - 50, y)
			var right_pos = Vector2i(x + 2 * map_width, y)
			var left_pos = Vector2i(x - 50, y)
			_flip_if_exists(FOREGROUND, og_right, right_pos)
			_flip_if_exists(BACKGROUND, og_right, right_pos)
			_flip_if_exists(FOREGROUND, og_left, left_pos)
			_flip_if_exists(BACKGROUND, og_left, left_pos)

## Helper function to flip a tile to a new position, if exists
func _flip_if_exists(layer, og, new):
	if tilemap.get_cell_source_id(layer, og) != -1:
		var sprite = tilemap.get_cell_atlas_coords(layer, og)
		tilemap.set_cell(layer, new, source_id, sprite)

## Generates all of the terrain from the noise maps.
func gen_terrain():
	gen_surface(true)
	gen_surface(false)
	gen_ore()
	gen_caves()
	gen_walls()
	gen_plants()
	
	for x in range(-map_width, map_width):
		for y in range(-100, map_height):
			var pos = Vector2i(x, y)
			if not pos in fg_tile_matrix:
				continue
			var val = fg_tile_matrix[pos]
			if val == 'DIRT':
				tilemap.set_cell(FOREGROUND, pos, source_id, SPRITE_DIRT)
			elif val == 'STONE':
				tilemap.set_cell(FOREGROUND, pos, source_id, SPRITE_STONE)
			elif val == 'DIRT_TOP':
				tilemap.set_cell(FOREGROUND, pos, source_id, SPRITE_DIRT_TOP)
			elif val == 'ORE1':
				tilemap.set_cell(FOREGROUND, pos, source_id, SPRITE_ORE1)
			elif val == 'CAVE':
				tilemap.set_cell(FOREGROUND, pos, -1)
				
	gen_cloned_sides()

# Called when the node enters the scene tree for the first time.
func _ready():
	#noise_grid = gen_noise_map()
	#gen_surface(true)
	#gen_surface(false)
	#gen_ore()
	#gen_caves()
	##gen_spawn_area()
	#gen_grass()
	#gen_plants()
	#gen_walls()
	#gen_cloned_sides()
	gen_terrain()
	
	#tilemap.set_cell(FOREGROUND, Vector2i(0,0), 1, Vector2i(2,6))
	#gen_normalized_terrain(map_width, map_height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
