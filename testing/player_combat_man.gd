extends Node2D
class_name PlayerCombat

@onready var stats : Stats = Stats.new(
	100,  	# health
	5, 		# defense
	20		# attack
)

@export var hitbox : Area2D = null
@export var hitboxSprite : Sprite2D = null
@export var hurtbox : Area2D = null

@export var player_controller : CharacterBody2D = null

@export var i_frames_sec = 1
@export var knockback_amt = 600

@onready var is_attacking := false

@onready var sword_hitbox := preload('res://testing/michael_sword.tscn')

func _ready() -> void:
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)


func _process(_delta) -> void:
	if Input.is_action_just_pressed("attack"):
		_animate_hitbox()
	


func _on_hurtbox_area_entered(area: Area2D):
	"""
	handles the player getting hit &
	i-frames
	"""
	if 'EnemyHit' in area.get_groups():
		var enemy : EnemyCombat = area.get_parent()
		stats.hp -= enemy.stats.get_raw_damage() - stats.b_def
		if stats.hp <= 0:
			print('[PLAYER]: dead as hell')
			return
			
		print('[PLAYER]: hp = ', stats.hp, '/', stats.max_hp)
		
		# calculate & apply knockback
		apply_knockback(area)
		
		# i frames
		hurtbox.area_entered.disconnect(_on_hurtbox_area_entered)
		await get_tree().create_timer(i_frames_sec).timeout
		hurtbox.area_entered.connect(_on_hurtbox_area_entered)


func apply_knockback(from: Area2D):
	#var dir = (from.global_position
				#.direction_to(player_controller.global_position)
				#.normalized())
	
	var dir = 1 if from.global_position.x < global_position.x else -1
	player_controller.velocity = knockback_amt * Vector2(dir, -1)


func _animate_hitbox():
	"""
	this whole fxn is used for testing...
	there will be a real animation here !!
	"""
	#hitbox.area_entered.connect(_on_hitbox_area_entered)
	is_attacking = true
	# spawn that sucka in
	var box = sword_hitbox.instantiate()
	add_child(box)
	hitboxSprite = box.get_child(1) 
	hitboxSprite.modulate.a = 1
	
	await get_tree().create_timer(1.5).timeout
	
	hitboxSprite.modulate.a = 0
	is_attacking = false
	box.queue_free()
	
	#print('so visible: ', hitbox.visible)
	#hitbox.area_entered.disconnect(_on_hitbox_area_entered)
