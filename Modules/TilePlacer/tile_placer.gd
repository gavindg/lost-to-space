extends TileMap

# put this on the tilemap !!!!!!! 

# bc this is on the tilemap right now. change this line if it is moved.
@onready var tilemap : TileMap = self
@export var player : CharacterBody2D = null
@onready var valid := false

# TODO make this a constant
@export var player_placement_radius = 200

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
	print("valid ? ", valid)

# this function could be optimized a bit
# but it would probably become unreadable
# as of right now, it'll stay like this
func _input(event: InputEvent) -> void:
	# for testing purposes
	if not valid:
		return
		
	if event is InputEventMouseButton && (event as InputEventMouseButton).pressed:
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
		
		print("foreground source: ", fg_source)
		print("background source: ", bg_source)
		
		if fg_source == 0:  # foreground tile is there, remove it
			remove_fg_at(map_position)
		else:
			# if there's a background tile there, let's place a block
			# in the foreground.
			if bg_source != -1:
				place_fg_at(map_position)
			
			else:
				var adj = get_adjacent_source_ids(map_position)
				for source in adj:
					if source != -1:
						place_fg_at(map_position)
					# TODO: check here if the foreground source exists...



# takes a position local to the player & checks if it is within
# the placable radius from the player

# TODO make this check that the player is not placing a block
# inside themself...
func in_range(local_pos):
	return abs(local_pos.length()) < player_placement_radius


# places test tile @ local_pos. it's assumed that this
func place_fg_at(map_position):
	tilemap.set_cell(FOREGROUND_LAYER, map_position, 
					test_atlas, test_atlas_coords)
					

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
