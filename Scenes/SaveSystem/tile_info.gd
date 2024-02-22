class_name TileInfo
extends Resource

@export var layer : int
@export var coords : Vector2
@export var atlas_id : int
@export var atlas_coords : Vector2

func place(map : TileMap):
	map.set_cell(layer, coords, atlas_id, atlas_coords)
