extends Node2D
class_name EnemyCombat

@onready var stats : Stats = Stats.new(
	100,  # health
	5,    # defense
	20    # attack
)

@export var hitbox : Area2D = null
@export var hurtbox : Area2D = null

func _ready() -> void:
	print('i have ', stats.hp, ' out of ', stats.max_hp, ' desu')
	# connect signals
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)


# collision between the player's hitbox and the enemy's hurtbox
# (aka PLAYER hit ENEMY)
func _on_hurtbox_area_entered(area: Area2D) -> void:
	# check if the body is the player's hitbox:
	if "PlayerHit" in area.get_groups():
		var player : PlayerCombat = area.get_parent()
		if not player.is_attacking:
			return
		stats.hp -= player.stats.get_raw_damage() - stats.b_def
		if stats.hp <= 0:
			print('[SLIMUS]: dead as hell')
		else:
			print('[SLIMUS]: hp = ', stats.hp, '/', stats.max_hp)
		
		# TODO: knockback shenanigans here
		# TODO: properly wire this up to the player
		
		# NOTE: in the current test scene, the player has no
		# hitbox. this fxn will not be called.
