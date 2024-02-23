class_name EnemyManager

extends Node2D

@export var despawnRadius : int = 800
@onready var despawn_freq : int = 600  # enemies will be despawned every 60 sec
@onready var tick := 0

@onready var enemies : Array[SpaceFiend] = []  # we'll want to change this to our actual enemy class

func _physics_process(_delta: float) -> void:
	print(tick)
	if (tick % despawn_freq == 0):
		despawn_enemies()
	tick += 1
	
	
func register(enemy):
	enemies.push_back(enemy);
	print("registered")
	

func deregister(enemy):
	enemies.remove_at(enemies.find(enemy))  # sorry
	
	
func out_of_range(enemy) -> bool:
	return true  # STUB
	

func despawn_enemies():
	print("despawning")
	for enemy in enemies:
		if out_of_range(enemy):
			print("deleting", enemy)
			deregister(enemy)
			enemy.queue_free()
