extends Node2D

@onready var rng = RandomNumberGenerator.new()
@export var player : CharacterBody2D = null

# enemy manager
@onready var manager : EnemyManager = %EnemyManager

# this is the denominator of the spawn rate for enemies
# so basically there is a 1 / (spawnRate) chance that an enemy will spawn per tick
@export var spawnRate : float = 200 

# how many pixels away an enemy will be spawned from the player
@export var radiusAwayFromPlayer : int = 400 

# how many pixels upwards relative to the players position is the enemy spawned
@export var upward_displacement : int = 50

# the enemy to be instantiated. just a test enemy as of right now...
@onready var enemy_prefab := preload("res://enemy_spawning/resources/enemies/slime/purple_slime.tscn")


# update
func _physics_process(delta: float) -> void:
	var random_num = rng.randf()
	if random_num < (1 / spawnRate):  # this might be really slow...
		spawn_enemy()


# spawns an enemy
func spawn_enemy():
	var sign = 1 if rng.randf() < 0.5 else -1
	if player == null:
		print("player not found")
		return
	var rand_pos_x : int = player.global_position.x + (radiusAwayFromPlayer * sign)
	var pos_y : int = player.global_position.y - upward_displacement  # because -y is up
	if enemy_prefab == null:
		print("enemy prefab invalid")
		return
	var enemy = enemy_prefab.instantiate()
	enemy.position = Vector2(rand_pos_x, pos_y)
	add_child(enemy)
	if manager != null:
		manager.register(enemy)
	print("spawning @", enemy.position)
