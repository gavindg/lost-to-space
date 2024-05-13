extends Node
class Block:
	var name: String
	var atlas_coords: Vector2i
	var mining_time: float
	var item_drop: String
	var primary_item: String

	# Constructor
	func _init(_name: String, _atlas_coords: Vector2i, _mining_time: float, _item_drop: String, _primary_item=""):
		name = _name
		atlas_coords = _atlas_coords
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
@export var map_width = 200
@export var map_height = 200

## flags
var player_locked : bool = false


var block_catalog = [
	Block.new("dirt0", Vector2i(0, 0), 50, "dirt"),
	Block.new("dirt1", Vector2i(0, 1), 50, "dirt"),
	Block.new("dirt2", Vector2i(0, 2), 50, "dirt"),
	Block.new("dirt3", Vector2i(0, 3), 50, "dirt"),
	Block.new("dirt4", Vector2i(1, 0), 50, "dirt"),
	Block.new("grass", Vector2i(2, 0), 50, "dirt"),
	Block.new("ore1", Vector2i(2, 1), 100, "ore"),
]




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
