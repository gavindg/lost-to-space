extends Node2D

@onready var rng = RandomNumberGenerator.new()
@onready var player : Vector2 = %TestPlayer.position

# enemy manager
@onready var manager : EnemyManager = %EnemyManager

# this is the denominator of the spawn rate for enemies
# so basically there is a 1 / (spawnRate) chance that an enemy will spawn per tick
@export var spawnRate : float = 200 

# how many pixels away an enemy will be spawned from the player
@export var radiusAwayFromPlayer : int = 400 

# the enemy to be instantiated. just a test enemy as of right now...
@onready var enemy_prefab := preload("res://enemy_spawning/resources/fiend/SpaceFiend.tscn")


# update
func _physics_process(delta: float) -> void:
	var random_num = rng.randf()
	if random_num < (1 / spawnRate):  # this might be really slow...
		spawn_enemy()


# spawns an enemy
func spawn_enemy():
	var sign = 1 if rng.randf() < 0.5 else -1
	var rand_pos_x = radiusAwayFromPlayer * sign
	var enemy = enemy_prefab.instantiate()
	enemy.position = Vector2(rand_pos_x, 10)
	add_child(enemy)
	if manager != null:
		manager.register(enemy)
	print("spawning @", enemy.position)
