extends Node2D

@export var despawnRadius : int = 800
@onready var despawn_freq : int = 60  # enemies will be despawned every 60 sec
@onready var tick := 0

@onready var enemies : Array = Array()

func _physics_process(_delta: float) -> void:
	if (tick % despawn_freq == 0):
		despawn_enemies()
	tick += 1
	
	
func register(enemy):
	enemies.push_back(enemy);
	

func deregister(enemy):
	enemies.remove_at(enemies.find(enemy))  # sorry
	
	
func out_of_range(enemy) -> bool:
	return false  # STUB
	

func despawn_enemies():
	for enemy in enemies:
		if out_of_range(enemy):
			deregister(enemy)
			enemy.queue_free()
