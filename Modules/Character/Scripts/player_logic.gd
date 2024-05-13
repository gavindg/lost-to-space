class_name PlayerLogic
extends Node2D

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
#var health = 100

# can be used for determining when to bring up end screen etc...
var player_alive = true
var attack_ip = false
var player_current_attack = false
var current_dir = "right"
const speed = 500

@onready() var hitbox = $"SwordArea"

@export var rotation_speed = 0

var cur_rotation_speed
func _ready():
	$"SwordArea/Sprite2D".visible = not $"SwordArea/Sprite2D".visible
	hitbox.set_deferred("disabled", true)

func _physics_process(_delta):
	#player_movement(delta)
	enemy_attack()
	attack()
	#if health <= 0:
		#player_alive = false # end screen / respawn
		#health = 0
		##self.queue_free()
		#print("YOU DEAD !!")

	if Globals.player_health <= 0:
		player_alive = false # end screen / respawn
		Globals.player_health = 0
		#self.queue_free()
		print("YOU DEAD !!")
		
	if player_current_attack:
		hitbox.rotation_degrees += cur_rotation_speed * _delta
		if hitbox.rotation_degrees > 360:
			hitbox.rotation_degrees -= 360

#func player_movement(delta):
	#if Input.is_action_pressed("ui_right"):
		#current_dir = "right"
		#velocity.x = speed
		#velocity.y = 0
	#elif Input.is_action_pressed("ui_left"):
		#current_dir = "left"
		#velocity.x = -speed
		#velocity.y = 0
	#elif Input.is_action_pressed("ui_down"):
		#current_dir = "down"
		#velocity.y = speed
		#velocity.x = 0
	#elif Input.is_action_pressed("ui_up"):
		#current_dir = "up"
		#velocity.y = -speed
		#velocity.x = 0
	#else:
		#velocity.x = 0
		#velocity.y = 0
		#
	#move_and_slide()

func player():
	pass
	
func _on_player_hitbox_body_entered(body):
	if "Enemy" in body.get_groups():
		enemy_in_attack_range = true


func _on_player_hitbox_body_exited(body):
	if "Enemy" in body.get_groups():
		enemy_in_attack_range = false
		
func enemy_attack():  # problem: not in range
	#print("enemy in attack range: ", enemy_in_attack_range, "\nenemy attack cooldown: ", enemy_attack_cooldown)
	if enemy_in_attack_range and enemy_attack_cooldown:
		#health = health - 20
		Globals.player_health -= 20
		print("current health: ", Globals.player_health)
		# go back to the Playtesting Scene from the Player Scene
		var parent = get_parent().get_parent().get_parent()
		# Go to the CanvasLayer Scene
		var UI_node = parent.get_node("UI").get_node("CanvasLayer")
		if UI_node and UI_node.has_method("update_health_bar"):
			UI_node.update_health_bar()
		enemy_attack_cooldown = false
		$attack_cooldown.start()


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
	

func attack():
	var dir = get_parent().exported_move_direction
	if (Input.is_action_just_pressed("attack") or Input.is_action_pressed("attack")) and not player_current_attack:
		player_current_attack = true
		attack_ip = true
		
		hitbox.set_deferred("disabled", false)
		if(!$"SwordArea/Sprite2D".visible):
			$"SwordArea/Sprite2D".visible = not $"SwordArea/Sprite2D".visible
		if dir <0:
			hitbox.rotation_degrees = 0
			#$AnimatedSprite2D.flip_h = false
			#$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
			cur_rotation_speed = -rotation_speed
		if dir >=0:
			hitbox.rotation_degrees = 180
			#$AnimatedSprite2D.flip_h = true
			#$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
			cur_rotation_speed = rotation_speed

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	player_current_attack = false
	attack_ip = false
	$"SwordArea/Sprite2D".visible = not $"SwordArea/Sprite2D".visible
	hitbox.set_deferred("disabled", true)
