class_name GameSaver
extends Node2D

# access to player & world for saving purposes
@onready var player = %TestPlayer
@onready var world = %WorldTileMap

# export vars
# TODO: make this support saving more than one tilemap layer !!
@export var saved_tilemap_layer : int = 0

# debug
@export var debug := false

# helps with race conditions ? maybe ?
var saving := false
var loading := false

# get user input
func _process(_delta: float) -> void:
	# save = 'K'
	if Input.is_action_just_pressed("save"):
		save_game()
	# load = 'L'
	if Input.is_action_just_pressed("load"):
		load_game()
	# clean = 'J'
	if Input.is_action_just_pressed("clean"):
		clean()


# this function saves some data about the player's position
# and all of the tiledata required to recreate the world
# TODO: make this extensible for multiple tilemaps
#  		this should be easy to do, just wanted to get this
# 		working first...
func save_game():
	if not loading:
		saving = true
		# format player data
		
		var save_data : SaveGameData = SaveGameData.new()
		save_data.player_gpos = player.global_position
		# TODO: remove...
		# not really a point in saving player velocity;
		# mostly here for me to just learn more about saving objects.
		save_data.player_velocity = player.velocity
		
		save_data.tilemap_layer = saved_tilemap_layer
		var tiles = world.get_used_cells(saved_tilemap_layer)  # gets all tiles
		for tile_pos in tiles:
			var info : TileInfo = TileInfo.new()
			info.layer = saved_tilemap_layer
			info.coords = tile_pos
			info.atlas_id = world.get_cell_source_id(saved_tilemap_layer, tile_pos)
			info.atlas_coords = world.get_cell_atlas_coords(saved_tilemap_layer, tile_pos)
			save_data.tile_data.push_back(info)  # save tiledata to this pos
		
		# store player data
		ResourceSaver.save(save_data, "user://save_game.tres")
		saving = false


# this function repopulates player and tilemap data 
# saved by save_game()...
func load_game():
	if not saving:
		loading = true
		clean()
		var save_data : SaveGameData = load("user://save_game.tres") as SaveGameData
		
		# load tile data
		for tile_info : TileInfo in save_data.tile_data:
			tile_info.place(world)
		
		# load player data
		player.global_position = save_data.player_gpos
		player.velocity = save_data.player_velocity
		loading = false 


# resets to the default world setup.
func clean():
	var save_data : SaveGameData = load("res://default_world.tres") as SaveGameData
	# erase all tiles
	var layer := save_data.tilemap_layer
	var tiles = world.get_used_cells(layer)
	for tile_pos in tiles:
		world.set_cell(layer, tile_pos, -1)  # -1 to erase a tile
	
	for tile_info : TileInfo in save_data.tile_data:
		tile_info.place(world)
