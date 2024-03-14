extends Node2D

@onready var rng = RandomNumberGenerator.new()
@export var player : CharacterBody2D = null
@export var tilemap : TileMap = null

# enemy manager
# @onready var manager : EnemyManager = %EnemyManager
@onready var manager = null

# this is the denominator of the spawn rate for enemies
# so basically there is a 1 / (spawnRate) chance that an enemy will spawn per tick
@export var spawnRate : float = 200 

# how many pixels away an enemy will be spawned from the player
@export var radiusAwayFromPlayer : int = 400 

# how many pixels upwards relative to the players position is the enemy spawned
@export var upward_displacement : int = 50

# the enemy to be instantiated. just a test enemy as of right now...
@onready var purple_slime_scene := preload("res://Modules/Enemies/EnemyAI/Scenes/purple_slime.tscn")
@onready var green_slime_scene := preload("res://Modules/Enemies/EnemyAI/Scenes/green_slime.tscn")

@onready var valid = false

func _ready():
	valid = player != null and tilemap != null


# update
func _physics_process(_delta: float) -> void:
	var random_num = rng.randf()
	if random_num < (1 / spawnRate) and valid:  # this might be really slow...
		spawn_enemy()


# spawns an enemy
# TODO: make this readable...
func spawn_enemy():
	var enemy_prefab = choose_enemy()
	var rand_sign = 1 if rng.randf() < 0.5 else -1
	var rand_pos_x : int = player.global_position.x + (radiusAwayFromPlayer * rand_sign)
	var pos_y := player.global_position.y - upward_displacement  # because -y is up
	
	# can't do nothin if the enemy doesn't exist...
	if enemy_prefab == null:
		print("enemy prefab invalid")
		return
		
	var enemy_pos = Vector2(rand_pos_x, pos_y)
	# pseudocode:
	if tile_source_at(enemy_pos) != -1:
		#print("tried to spawn an enemy in a wall...")
		return
	
	var enemy = enemy_prefab.instantiate()
	enemy.position = enemy_pos
	add_child(enemy)
	if manager != null:
		manager.register(enemy)
	
	#print("spawn successfull!")


func tile_source_at(pos):
	var map_local := tilemap.to_local(pos)
	var tilemap_pos := tilemap.local_to_map(map_local)
	
	return tilemap.get_cell_source_id(0, tilemap_pos)


# the idea is that this function randomly chooses an enemy to spawn
# we only have 1 working enemy atm...
func choose_enemy():
	return green_slime_scene # purple_slime_scene if rng.randf() > 0.5 else green_slime_scene
