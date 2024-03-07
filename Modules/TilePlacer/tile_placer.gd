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
const test_atlas = 2
const test_atlas_coords = Vector2i(0, 0)


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
		var source_at_click := tilemap.get_cell_source_id(0, map_position)
		
		print("source of this tile: ", source_at_click)
		
		if source_at_click == -1:
			place_at(map_position)
		elif source_at_click != 1:  # if it's 1, that's a bg tile. i'm not messing w those as of now.
			remove_at(map_position)



# takes a position local to the player & checks if it is within
# the placable radius from the player

# TODO make this check that the player is not placing a block
# inside themself...
func in_range(local_pos):
	return abs(local_pos.length()) < player_placement_radius


# places test tile @ local_pos. it's assumed that this
func place_at(map_position):
	tilemap.set_cell(test_layer, map_position, 
					test_atlas, test_atlas_coords)
					

func remove_at(map_position):
	tilemap.set_cell(test_layer, map_position, -1)
