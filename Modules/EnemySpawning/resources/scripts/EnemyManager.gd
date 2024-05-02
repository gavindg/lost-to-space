class_name EnemyManager

extends Node2D

@export var enemyDespawnDistance = 3000;
@export var minDespawnRange = 200;

var maxEnemiesByType = {
	"greenSlime": 10
}

var enemyDict = {
	"greenSlime": {}
}
	
	
func register(enemy):
	# find enemy dict by cname then add to dict
	enemyDict[enemy.enemy_type][enemy.get_instance_id()] = enemy

# Allow / Deny spawn based on number of existing enemies of same type
func allowEnemySpawn(enemy_type):
	if len(enemyDict[enemy_type]) > maxEnemiesByType[enemy_type]:
		print("hit enemy cap, not spawning")
		return false
	else:
		return true
	
func deregister(enemy_id, enemy_name):
	enemyDict[enemy_name].erase(enemy_id)
	
func is_out_of_range(enemy, player):
	var player_pos = player.global_position
	var enemy_pos = enemy.global_position
	
	var distance = player_pos.distance_to(enemy_pos)
	
	if distance > enemyDespawnDistance:
		print("DISTANCE: "+str(distance))
		return true
	else:
		return false

func despawn(enemy):
	var enemy_id = enemy.get_instance_id()
	var enemy_name = enemy.enemy_type
	enemy.queue_free()
	deregister(enemy_id, enemy_name)
	print("despawned")
	
func check_enemies(player):
	for key in enemyDict:
		for enemyID in enemyDict[key]:
			if is_out_of_range(enemyDict[key][enemyID], player):
				despawn(enemyDict[key][enemyID])
