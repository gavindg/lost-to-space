extends Node2D

@onready var rng = RandomNumberGenerator.new()
@export var player : CharacterBody2D = null
@export var tilemap : TileMap = null

# load enemy manager class
const managerScript = preload("res://Modules/EnemySpawning/resources/scripts/EnemyManager.gd")
@onready var manager = managerScript.new()

# this is the denominator of the spawn rate for enemies
# so basically there is a 1 / (spawnRate) chance that an enemy will spawn per tick
@export var globalSpawnRate : float = 200

# the enemy to be instantiated. just a test enemy as of right now...
@onready var enemies = {
	"greenSlime": preload("res://Modules/Enemies/EnemyAI/Scenes/green_slime.tscn"),
	# add new enemies here
}

# areas where enemies cannot spawn
var safe_zones = [
	Rect2i(Vector2i(0, 0), Vector2i(500, 75))
]

var spawntable = []

func _ready():
	construct_enemy_spawntable()


func _physics_process(_delta):
	print(player.global_position)
	if (rng.randf() < (1 / globalSpawnRate)):
		spawn_enemy()
	manager.check_enemies(player)
	
func construct_enemy_spawntable():
	for key in manager.enemyData:
		var choices = manager.enemyData[key]["spawn_rate"] * 10
		assert(choices == floor(choices))
		
		for _x in choices:
			spawntable.append(key)
			
func choose_enemy():
	return spawntable[randi() % spawntable.size()]
	
func spawn_enemy():
	# TODO: add spawn types (surface, cave, deep, etc...)
	var enemy_name = choose_enemy()
	var enemy_prefab = enemies[enemy_name]
	
	var rad_min = manager.enemyData[enemy_name]["spawn_rad_min"]
	var rad_max = manager.enemyData[enemy_name]["spawn_rad_max"]
	
	var rand_sign = 1 if rng.randf() < 0.5 else -1
	var radius_away = randi_range(rad_min, rad_max)
	
	var rand_pos_x : int = player.global_position.x + (radius_away * rand_sign)
	
	var pos_y := player.global_position.y - 40  # because -y is up
	
	var enemy_pos = Vector2i(rand_pos_x, pos_y)
	
	if tile_source_at(enemy_pos) != -1:
		#print("tried to spawn an enemy in a wall...")
		return
		
	for zone in safe_zones:
		if zone.has_point(enemy_pos):
			return
	
	var enemy = enemy_prefab.instantiate()
	enemy.position = enemy_pos
	add_child(enemy)
	manager.register(enemy)
	
func tile_source_at(pos):
	var map_local := tilemap.to_local(pos)
	var tilemap_pos := tilemap.local_to_map(map_local)
	
	return tilemap.get_cell_source_id(0, tilemap_pos)
