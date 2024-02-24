extends Node2D

var speed = 40
var player_chase = false
var player = null  # this is a CharacterBody2D

var health = 100
var player_inattack_zone = false
var can_take_damage = true

func _physics_process(_delta):

	deal_with_damage()
	
	#if player_chase:
		#velocity = (player.get_global_position() - position).normalized()*speed*delta
	#else:
		#velocity = lerp(velocity, Vector2.ZERO, 0.07)
	# Does it not collide if you don't call this ..?
	#move_and_collide(velocity)
		#position += (player.position - position)/speed
		
		

func _on_detection_area_body_entered(body):
	player = body
	#player_chase = true
	


func _on_detection_area_body_exited(_body):
	player = null
	#player_chase = false

func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if "Player" in body.get_groups(): # has_method("player"):
		player = body 
		player_inattack_zone = true
	else:
		pass
		#print("player not found")


func _on_enemy_hitbox_body_exited(body):
	if "Player" in body.get_groups():
		player_inattack_zone = false
	
	
func deal_with_damage():
	if player == null:
		return
	var player_logic : PlayerLogic = player.get_node("CombatHandling")
	
	if player_inattack_zone and player_logic.player_current_attack:
		#print("am i real")
		if can_take_damage:
			health = health - 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("Enemy health = ", health)
			if health <= 0:
				self.queue_free()


func _on_take_damage_cooldown_timeout():
	can_take_damage = true
