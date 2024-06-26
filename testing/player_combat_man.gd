extends Node2D
class_name PlayerCombat

@onready var stats : Stats = Stats.new(
	100,  	# health
	5, 		# defense
	20		# attack
)

@export var hitbox : Area2D = null
@export var hurtbox : Area2D = null

@export var player_controller : CharacterBody2D = null
@onready var facing = 1
@onready var displacement = 8

@onready var i_frames_sec = 1
@onready var knockback_amt = 200
@onready var current_id = 1

@onready var is_attacking := false
var is_dead = false

@onready var sword_hitbox := preload('res://testing/michael_sword.tscn')
@export var sword_rotation_speed := 400


func _ready() -> void:
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	$"SwordArea/Sprite2D".visible = false
	hitbox.set_deferred("enabled", false)

func _process(delta: float) -> void:
	# animate hitbox
	pass
	#_animate_weapon(delta)

signal player_attack	

func _input(event: InputEvent) -> void:
	if is_dead: return
	if is_attacking: return
	if event is InputEventMouseButton && (event as InputEventMouseButton).pressed && (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		
		if not Globals.inv_manager.held_item or Globals.inv_manager.held_item.name != "Sword":
			return
		
		var global_pos := get_global_mouse_position()
		var local_to_player := player_controller.to_local(global_pos)
		if local_to_player.x > 0:
			facing = 1
		elif local_to_player.x < 0:
			facing = -1
		_animate_hitbox()
		player_attack.emit(facing)

func _on_hurtbox_area_entered(area: Area2D):
	"""
	handles the player getting hit &
	i-frames
	"""
	if is_dead: return
	
	if 'EnemyHit' in area.get_groups():
		var enemy : EnemyCombat = area.get_parent()
		# take damage
		stats.hp -= enemy.stats.get_raw_damage() - stats.b_def
		
		# update the value in globals...
		if Globals.player_health: Globals.player_health = stats.hp
		
		if stats.hp <= 0:
			is_dead = true
			die()
			return
		
		# calculate & apply knockback
		apply_knockback(area)
		
		# i frames  TODO: make the player flash here !!!!!!
		hurtbox.area_entered.disconnect(_on_hurtbox_area_entered)
		await get_tree().create_timer(i_frames_sec).timeout
		hurtbox.area_entered.connect(_on_hurtbox_area_entered)


func apply_knockback(from: Area2D):
	if is_dead: return
	var dir = 1 if from.global_position.x < global_position.x else -1
	player_controller.velocity = knockback_amt * Vector2(dir, -1)

func _animate_hitbox():
	"""
	this whole fxn is used for testing...
	there will be a real animation here !!
	"""
	if not is_attacking:
		is_attacking = true
		
		### START NOT MY CODE BLOCK ###
		
		#hitbox.set_deferred("disabled", false)
		#if(!$"SwordArea/Sprite2D".visible):
			#$"SwordArea/Sprite2D".visible = not $"SwordArea/Sprite2D".visible
		#if facing > 0:
			#hitbox.rotation_degrees = 0 - 90
			#hitbox.global_position.x = global_position.x
		#if facing <= 0:
			#hitbox.rotation_degrees = 180 + 90
			#hitbox.global_position.x = global_position.x
		
		### END NOT MY CODE BLOCK ###
		
		#var box : Node2D = sword_hitbox.instantiate()
		
		# give the hitbox a unique id
		# NOTE: i think this will still work but like. maybe not
		hitbox.set_meta("ID", current_id) 
		current_id += 1
		if facing > 0:
			hitbox.rotation_degrees = 30
			hitbox.position = Vector2i(7.5, 6)
			animate_sword_right()
		else:
			hitbox.rotation_degrees = -1*(30 + 180)
			hitbox.position = Vector2i(-7.5, 6)
			animate_sword_left()
		
		await get_tree().create_timer(0.4).timeout
		
		#$deal_attack_timer.stop()
		is_attacking = false
		#attack_ip = false # NOTE: welp. i hiope this waas not important
		$"SwordArea/Sprite2D".visible = not $"SwordArea/Sprite2D".visible
		hitbox.set_deferred("disabled", true)
		
		## remove the hitbox
		#is_attacking = false
		#box.queue_free()

func animate_sword_right():
	await get_tree().create_timer(0.05).timeout
	if(!$"SwordArea/Sprite2D".visible):
		$"SwordArea/Sprite2D".visible = not $"SwordArea/Sprite2D".visible
	hitbox.rotation_degrees = -122
	hitbox.position = Vector2(-7, -4.5)
	await get_tree().create_timer(0.025).timeout
	hitbox.rotation_degrees = 270
	hitbox.position = Vector2(-1, -8)
	await get_tree().create_timer(0.025).timeout
	hitbox.rotation_degrees = -52
	hitbox.position = Vector2(4, -4.5)
	await get_tree().create_timer(0.025).timeout
	hitbox.rotation_degrees = -20
	hitbox.position = Vector2(10, 0)
	await get_tree().create_timer(0.025).timeout
	hitbox.rotation_degrees = 30
	hitbox.position = Vector2i(7.5, 6)
	await get_tree().create_timer(0.25).timeout
	
func animate_sword_left():
	await get_tree().create_timer(0.05).timeout
	if(!$"SwordArea/Sprite2D".visible):
		$"SwordArea/Sprite2D".visible = not $"SwordArea/Sprite2D".visible
	hitbox.rotation_degrees = -122 + 180
	hitbox.position = Vector2(7, -4.5)
	await get_tree().create_timer(0.025).timeout
	hitbox.rotation_degrees = -270 + 180
	hitbox.position = Vector2(1, -8)
	await get_tree().create_timer(0.025).timeout
	hitbox.rotation_degrees = -1*(-52 + 180)
	hitbox.position = Vector2(-4, -4.5)
	await get_tree().create_timer(0.025).timeout
	hitbox.rotation_degrees = -1*(-20 + 180)
	hitbox.position = Vector2(-10, 0)
	await get_tree().create_timer(0.025).timeout
	hitbox.rotation_degrees = -1*(30 + 180)
	hitbox.position = Vector2i(-7.5, 6)
	await get_tree().create_timer(0.25).timeout
	

func _animate_weapon(delta):
	if is_attacking:
		hitbox.rotation_degrees += facing * sword_rotation_speed * delta
		if hitbox.rotation_degrees > 360:
			hitbox.rotation_degrees -= 360
	pass

func die():
	# TODO: do something here when the player dies !!!!
	pass
