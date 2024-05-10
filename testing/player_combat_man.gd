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
@export var facing = 1

@export var i_frames_sec = 1
@export var knockback_amt = 200
@onready var current_id = 1

@onready var is_attacking := false

@onready var sword_hitbox := preload('res://testing/michael_sword.tscn')

func _ready() -> void:
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)


func _process(_delta) -> void:
	if player_controller.velocity.x > 0:
		facing = 1
	elif player_controller.velocity.x < 0:
		facing = -1
	
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
	var dir = 1 if from.global_position.x < global_position.x else -1
	player_controller.velocity = knockback_amt * Vector2(dir, -1)


func _animate_hitbox():
	"""
	this whole fxn is used for testing...
	there will be a real animation here !!
	"""
	if not is_attacking:
		is_attacking = true
		
		var box : Node2D = sword_hitbox.instantiate()
		
		# give the hitbox a unique id
		box.set_meta("ID", current_id)
		current_id += 1
		
		# scuffed: place the hitbox in the players dir
		
		
		
		# spawn that sucka in
		add_child(box)
		box.global_position.x += facing * 20  # 20 px displacement
		hitboxSprite = box.get_child(1) 
		hitboxSprite.modulate.a = 1
		
		await get_tree().create_timer(0.35).timeout
		
		# remove the hitbox
		hitboxSprite.modulate.a = 0
		is_attacking = false
		box.queue_free()
