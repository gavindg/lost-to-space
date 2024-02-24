extends Node2D

@export var world : TileMap = null
@export var player : CharacterBody2D = null

# export variables
@export var block_atlas_coords : Vector2i = Vector2i(0, 0)
@export var player_block_placement_radius := 300.0

# for printing debug statements
@export var debug_messages : bool = false


func _unhandled_input(event: InputEvent) -> void:
	# on click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# first check if click was within the player's placement radius
		var click_pos : Vector2 = event.global_position
		if click_pos.distance_to(player.global_position) < player_block_placement_radius:
			# convert global click coords to map coords
			var coords = world.local_to_map(world.to_local(click_pos))
			
			# place block
			world.set_cell(0, coords, 0, block_atlas_coords)
			
			# debug
			if debug_messages:
				print("click @", event.global_position)
				print("placing @", coords)
				
		# if the click was too far
		elif debug_messages:
			print("click (too far) @", event.position)
			print("player @", player.global_position)
			print("distance:", click_pos.distance_to(player.global_position))
