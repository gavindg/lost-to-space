extends Node2D
class_name EnemyCombat

@onready var stats : Stats = null

@export var health = 100
@export var defense = 2
@export var attack = 7.5

@export var hitbox : Area2D = null
@export var hurtbox : Area2D = null

@export var auto_start = true
@export var to_kill : Node2D = null

# if this enemy has boss music...
#@export var musician : AudioStreamPlayer = null
@export var healthbar : ProgressBar
var is_dead : bool = false

var hitme = []

func _ready():
	if auto_start:
		start()

func start():
	stats = Stats.new(health, defense, attack)
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	
	if healthbar:
		healthbar.max_value = stats.max_hp
		healthbar.value = stats.max_hp
		healthbar.visible = true
	#print('i have ', stats.hp, ' out of ', stats.max_hp, ' desu')
	# connect signals


# collision between the player's hitbox and the enemy's hurtbox
# (aka PLAYER hit ENEMY)
func _on_hurtbox_area_entered(area: Area2D) -> void:
	# check if the body is the player's hitbox:
	if "PlayerHit" in area.get_groups() and area.get_meta("ID") not in hitme:
		var player : PlayerCombat = area.get_parent()
		if not player.is_attacking:
			return
		
		# to make sure that we don't get hit by
		# the same hitbox twice
		if len(hitme) < 10:
			hitme.append(area.get_meta("ID"))
		else:
			hitme = [area.get_meta("ID")]
		
		stats.hp -= player.stats.get_raw_damage() - stats.b_def
		if healthbar:
			healthbar.value = stats.hp
		if stats.hp <= 0:
			die()

func die():
	is_dead = true
	if healthbar:
		healthbar.queue_free()
	if auto_start and to_kill:
		Globals.manager.despawn(to_kill)
