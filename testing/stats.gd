class_name Stats

var hp : int = -1
var max_hp : int = -1
var b_def : int = -1  		# index 0
var b_atk : int = -1	# index 1
var status_effects : Array = []

func _init(health : int, defense : int, attack : int) -> void:
	hp = health
	max_hp = health
	b_def = defense
	b_atk = attack
	status_effects = []


func receive_damage(raw_damage : int):
	# would be great to just pass a ref to the player's stats here;
	# that way we could apply buffs/debuffs based on player's weapon,
	# items, etc.
	var stats : Array = calculated_stats()
	var def : int = stats[0]
	hp -= raw_damage - def
	if hp <= 0:
		die()


func get_raw_damage():
	var stats : Array = calculated_stats()
	var dmg_amt = stats[1]
	return dmg_amt


func get_stats():
	var stats = get_stats()
	print('hp = ', hp, '/', max_hp, 
		'\ndef = ', stats[0], '/', b_def,
		'\natk = ', stats[1], '/', b_atk)


# returns the enemy's stats after considering their 
func calculated_stats():
	for effect in status_effects:
		# do something to the stats depending on what type they are
		pass
	return [b_def, b_atk]

# idk do some enemy management activity here
func die():
	pass
