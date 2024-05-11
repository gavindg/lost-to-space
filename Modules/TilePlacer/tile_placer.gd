extends TileMap

# put this on the tilemap !!!!!!! 

# bc this is on the tilemap right now. change this line if it is moved.
@onready var tilemap : TileMap = self
@onready var ghost_tile_map = get_parent().get_node("GhostTileMap")
@export var player : CharacterBody2D = null
@export var player_nobuild_size = Vector2(15, 30)
var player_ghost_block_pos = Vector2i()
@onready var valid := false

# TODO make this a constant
@export var player_placement_radius = 100

# test constants  # TODO change these after testing !!
const test_layer = 0
const test_atlas = 0
const test_atlas_coords = Vector2i(0, 0)

const FOREGROUND_LAYER = 1
const BACKGROUND_LAYER = 0
const SOURCE = 0


func _ready() -> void:
	if tilemap != null && player != null:
		valid = true
	#print("valid ? ", valid)

# this function could be optimized a bit
# but it would probably become unreadable
# as of right now, it'll stay like this
func _input(event: InputEvent) -> void:
	# for testing purposes
	if not valid:
		return
	
	# update ghost block
	if Globals.inv_manager.held_item is Placeable:
		if event is InputEventMouseMotion or event is InputEventKey or event is InputEventMouse:
			var global_pos := get_global_mouse_position()
			var local_to_player := player.to_local(global_pos)
			#
			if (!in_range(local_to_player)):
				return
			
			# now get the tilemap position
			var local_to_tilemap := tilemap.to_local(global_pos)
			var map_position := tilemap.local_to_map(local_to_tilemap)
			
			if map_position != player_ghost_block_pos:
				# postiion has changed, get rid of old ghost block
				remove_ghost_block_at(player_ghost_block_pos)
			
			# don't let the player suffocate themself
			if (!in_player_bounds(map_position)):
				var fg_source := tilemap.get_cell_source_id(FOREGROUND_LAYER, map_position)
				if fg_source != 0:
					var bg_source := tilemap.get_cell_source_id(BACKGROUND_LAYER, map_position)
					if bg_source != -1:
						player_ghost_block_pos = map_position
						place_ghost_block_at(map_position)
						
					else:
						var adj = get_adjacent_source_ids(map_position)
						var is_adj = false
						for source in adj:
							if source != -1:
								is_adj = true
						if is_adj:
							player_ghost_block_pos = map_position
							place_ghost_block_at(map_position)
	else:
		#player has stopped holding a placeable block
		remove_ghost_block_at(player_ghost_block_pos)
	
	
	if event is InputEventMouseButton && (event as InputEventMouseButton).pressed && (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		# get the local position of the mouse cick on this canvas item
		var global_pos := get_global_mouse_position()
		var local_to_player := player.to_local(global_pos)
		#
		if (!in_range(local_to_player)):
			return
		
		
		# now get the tilemap position of the click.

		var local_to_tilemap := tilemap.to_local(global_pos)
		var map_position := tilemap.local_to_map(local_to_tilemap)
		
		# depending on what's there, we do something different.
		var fg_source := tilemap.get_cell_source_id(FOREGROUND_LAYER, map_position)
		var bg_source := tilemap.get_cell_source_id(BACKGROUND_LAYER, map_position)
		
		#print("foreground source: ", fg_source)
		#print("background source: ", bg_source)
		
		print(map_position)
		
<<<<<<< HEAD
		#if fg_source == 0:
			#if Globals.inv_manager.held_item is Tool:  # foreground tile is there, remove it
				##start_mining(map_position)
				#remove_fg_at(map_position)
				#if map_position.x <= -Globals.map_width:
					#remove_fg_at(map_position+Vector2i(Globals.map_width * 2, 0))
				#elif map_position.x >= Globals.map_width-1:
					#remove_fg_at(map_position-Vector2i(Globals.map_width*2, 0))
		#elif Globals.inv_manager.held_item is Placeable:
			## don't let the player suffocate themself
			#if (in_player_bounds(map_position)):
				#return
			## if there's a background tile there, let's place a block
			## in the foreground.
			#if bg_source != -1 && Globals.inv_manager.remove_dirt():
				#place_fg_at(map_position)
			#else:
				#var adj = get_adjacent_source_ids(map_position)
				#var is_adj = false
				#for source in adj:
					#if source != -1:
						#is_adj = true
				#if is_adj and Globals.inv_manager.remove_dirt():
					#place_fg_at(map_position)
					## TODO: check here if the foreground source exists...
=======

		
		if fg_source == 0:
			if Globals.inv_manager.held_item is Tool:  # foreground tile is there, remove it
				#start_mining(map_position)
				remove_fg_at(map_position)
		        if map_position.x <= -Globals.map_width:
		        	remove_fg_at(map_position+Vector2i(Globals.map_width * 2, 0))
		        elif map_position.x >= Globals.map_width-1:
		        	remove_fg_at(map_position-Vector2i(Globals.map_width*2, 0))
		elif Globals.inv_manager.held_item is Placeable:
			# don't let the player suffocate themself
			if (in_player_bounds(map_position)):
				return
			# if there's a background tile there, let's place a block
			# in the foreground.
			if bg_source != -1 && Globals.inv_manager.remove_dirt():
				place_fg_at(map_position)
			else:
				var adj = get_adjacent_source_ids(map_position)
				var is_adj = false
				for source in adj:
					if source != -1:
						is_adj = true
				if is_adj and Globals.inv_manager.remove_dirt():
					place_fg_at(map_position)
					# TODO: check here if the foreground source exists...
>>>>>>> parent of f91b103 (Revert "Merge branch 'main' into world-gen-modular")



# takes a position local to the player & checks if it is within
# the placable radius from the player

func in_range(local_pos):
	return abs(local_pos.length()) < player_placement_radius

# takes a tilemap position and checks if the player is currently occupying that block
func in_player_bounds(block_pos):
	# get a list of nobuild tilemap coordinates based on the player's position
	var left_bound = player.global_position.x - (player_nobuild_size.x / 2)
	var right_bound = player.global_position.x + (player_nobuild_size.x / 2)
	var upper_bound = player.global_position.y - (player_nobuild_size.y / 2)
	var lower_bound = player.global_position.y + (player_nobuild_size.y / 2) - 12
	var nobuild_blocks = []
	
	# a traditional for loop would be really nice to have here
	
	# THE A L G O R I T H M
	var x = left_bound
	var y = upper_bound
	while x <= right_bound:
		while y <= lower_bound:
			var block = tilemap.local_to_map(tilemap.to_local(Vector2(x,  y)))
			if nobuild_blocks.find(block) == -1:
				nobuild_blocks.append(block)
			y += (player_nobuild_size.y / 2)
		
		y = upper_bound
		x += (player_nobuild_size.x / 2)
		
	return nobuild_blocks.find(block_pos) != -1
	
	

func start_mining(block_pos):
	pass
	
	
func break_block(block_pos):
	var atlas_coords = tilemap.get_cell_atlas_coords(FOREGROUND_LAYER, block_pos)
	remove_fg_at(block_pos)
	if(atlas_coords.x == 0 or atlas_coords == Vector2i(1,0) or atlas_coords == Vector2i(2,0)):
		Globals.inv_manager.give_dirt()
	elif(atlas_coords == Vector2i(2,1)):
		Globals.inv_manager.give_ore()
		

# places test tile @ local_pos. it's assumed that this
func place_fg_at(map_position):
	# remove any existing ghost block at map_pos
	remove_ghost_block_at(map_position)
	
	#place the block
	tilemap.set_cell(FOREGROUND_LAYER, map_position, 
					test_atlas, test_atlas_coords)

func place_ghost_block_at(map_position):
	ghost_tile_map.set_cell(BACKGROUND_LAYER, map_position, test_atlas, test_atlas_coords)
	
func remove_ghost_block_at(map_position):
	ghost_tile_map.set_cell(BACKGROUND_LAYER, map_position, -1)


func remove_fg_at(map_position):
	tilemap.set_cell(FOREGROUND_LAYER, map_position, -1)


func get_adjacent_source_ids(map_position):
	var adj = []
	adj.append(tilemap.get_cell_source_id(FOREGROUND_LAYER,
				 map_position + Vector2i.LEFT))
	adj.append(tilemap.get_cell_source_id(FOREGROUND_LAYER,
				 map_position + Vector2i.UP))
	adj.append(tilemap.get_cell_source_id(FOREGROUND_LAYER,
				 map_position + Vector2i.RIGHT))
	adj.append(tilemap.get_cell_source_id(FOREGROUND_LAYER,
				 map_position + Vector2i.DOWN))
	return adj
