extends Node

#game manager
var game_manager
var death_ui

class Block:
	var name: String
	var atlas_coords: Vector2i
	var atlas_id : int
	var mining_time: float
	var item_drop: String
	var primary_item: String

	# Constructor
	func _init(_name: String, _atlas_coords: Vector2i, _atlas_id : int, _mining_time: float, _item_drop: String, _primary_item=""):
		name = _name
		atlas_coords = _atlas_coords
		atlas_id = _atlas_id
		mining_time = _mining_time
		item_drop = _item_drop
		primary_item = _primary_item # Some items in your inventory transform into a block when placed. That block is defined by the 'primary item'.
		

func get_block_by_atlas_coords(atlas_coords: Vector2i) -> Block:
	# too lazy to do a hashmap, plus theres very few blocks to cycle thru
	for block in block_catalog:
		if block.atlas_coords == atlas_coords:
			return block
	return null

func get_block_by_item(item: String) -> Block:
	for block in block_catalog:
		if block.primary_item == item:
			return block
	return null

	
# health
var player_health = 100
var inv_manager
var player
var manager



# World Gen
@export var map_width = 240
@export var map_height = 240

## flags
var player_locked : bool = false


var block_catalog = [
	Block.new("DIRT0", Vector2i(0, 0), 0, 50, "dirt", "dirt"), # dirt0 is the primary block for the dirt item
	Block.new("DIRT1", Vector2i(0, 1), 0, 50, "dirt"),
	Block.new("DIRT2", Vector2i(0, 2), 0, 50, "dirt"),
	Block.new("DIRT3", Vector2i(0, 3), 0, 50, "dirt"),
	Block.new("DIRT4", Vector2i(1, 0), 0, 50, "dirt"),
	Block.new("GRASS", Vector2i(2, 0), 0, 50, "dirt"),
	#Block.new("ore1", Vector2i(2, 1), 0, 100, "ore", "ore"),
	Block.new("ORE0", Vector2i(0,0), 5, 100, "ore", "ore"),
	Block.new("ORE1", Vector2i(0,1), 5, 100, "ore", "ore"),
	Block.new("ORE2", Vector2i(0,2), 5, 100, "ore", "ore"),
	Block.new("ORE3", Vector2i(0,3), 5, 100, "ore", "ore"),
]

#Pause
var pause_menu

var foreground_tiles = {}
var terrain_ground_levels = {}

func open_death_ui():
	death_ui.visible = true
	player.visible = false
	get_tree().paused = true

func unpause():
	get_tree().paused = false

## movement
## initial walk speed
#@export var SPEED = 200.0
## initial jump speed
#@export var JUMP_SPEED = -300.0
## maximum falling speed
#const VERTICAL_SPEED_LIMIT = 600
## sliding wall gravity (to make falling when colliding against wall slower)
#const SLIDING_GRAVITY = 200
## dash speed
#const DASH_SPEED = 300
## additional double jump speed
#const DOUBLE_JUMP_SPEED = -300
## initial speed to move away from the wall (to the opposite direction)
#const WALL_JUMP_SPEED_AGAINST_WALL = 200
## initial speed to move up from the wall
#const WALL_JUMP_SPEED_UPWARDS = -300
