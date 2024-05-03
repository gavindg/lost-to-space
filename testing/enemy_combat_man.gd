extends Node2D

@onready var stats : EnemyStats = EnemyStats.new(
	100,  # health
	5,    # defense
	20    # attack
)

@export var hitbox : Area2D = null
@export var hurtbox : Area2D = null

var valid = true

func _ready() -> void:
	# connect signals
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)


# collision between the player hurtbox & enemy hitbox occurred !
# (aka ENEMY hit PLAYER)
func _on_hitbox_area_entered(area: Area2D) -> void:	
	# check if the body is the player's hurtbox:
	if "PlayerHurt" in area.get_groups():
		stats.get_raw_damage()  # player.take_damage(stats.get_raw_damage)
		# TODO: properly wire this up to the player
		
		# (these should really be done on the player's side)
		# TODO: player knockback shenanigans here
		# TODO: perchance activate the player's iframes?
	

# collision between the player's hitbox and the enemy's hurtbox
# (aka PLAYER hit ENEMY)
func _on_hurtbox_area_entered(area: Area2D) -> void:
	# check if the body is the player's hitbox:
	if "PlayerHit" in area.get_groups():
		stats.receive_damage(10000)  # wow !! so powerfu !!
		# TODO: knockback shenanigans here
		# TODO: properly wire this up to the player
		
		# NOTE: in the current test scene, the player has no
		# hitbox. this fxn will not be called.
