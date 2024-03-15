class_name Slime

extends RigidBody2D

var velocity = Vector2()
@export var speed = 50 #speed of slime
var wander_timer = 0.0; # internal timer for wander
@export var min_wander_interval = 1 # min time in seconds that the slime will wander in one direction
@export var max_wander_interval = 2 # max time in seconds that the slime will wander in one direction
@export var gravity_strength = 10
var is_jumping = false
var in_combat = false

# for animations
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#print("Ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# applies gravity and subtracts from wander timer
	velocity.y += gravity_strength * delta
	wander_timer -= delta;
	#checks for combat
	if in_combat:
		seek()
	else:
		wander()
	move_and_collide(velocity)
	
	# TODO: animation player is null for some reason...
	
	# animate (WIP)
	if animation_player != null:
		if is_jumping && velocity.x != 0:
			if velocity.x < 0:  # its moving left
				animation_player.play("grounded_left")
			elif velocity.x > 0:
				animation_player.play("grounded_right")
		else:
			animation_player.play("idle")
	else:
		print("animation player is null")

# the wander function of the slime
func wander():
	# if the wander timer is run down, choose the direction towards the player and move by it. 
	if wander_timer <= 0.0 && !is_jumping:
		is_jumping = true;
		
		velocity.y = -speed * cos(deg_to_rad(45)) 
		velocity.x = speed * sin(deg_to_rad(45))
		
		# Randomly multiply velocity.x by 1 or -1 
		var random_x = randf_range(-1, 1)
		if random_x > 0:
			random_x = 1
		else:
			random_x = -1
		
		#multiplies chosen value
		velocity.x *= random_x
		
		#sets next wander interval to a random value
		var wander_interval = randf_range(min_wander_interval, max_wander_interval)
		
		wander_timer = wander_interval
	else:
		is_jumping = false;
		
		
#seeks the player and jumps towards the player
func seek():
	# if the wander timer is run down, choose a random direction and move by it. 
	if wander_timer <= 0.0 && !is_jumping:
		is_jumping = true;
		
		velocity.y = -speed * cos(deg_to_rad(45)) 
		velocity.x = speed * sin(deg_to_rad(45))
		
		# Randomly multiply velocity.x by 1 or -1 depending on the direction of the player
		var direction_x = calculate_direction_towards_player()
		if direction_x > 0:
			direction_x = 1
		else:
			direction_x = -1
		
		#multiplies chosen value
		velocity.x *= direction_x
		
		#sets next wander interval to a random value
		var wander_interval = randf_range(min_wander_interval, max_wander_interval)
		
		wander_timer = wander_interval
	else:
		is_jumping = false;

func calculate_direction_towards_player():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]  # For simplicity, consider the first player in the group
		var direction = player.global_position.x - global_position.x
		return direction
	else:
		return Vector2.ZERO  # No players found, return zero vector or handle accordingly

func _on_detection_area_2d_body_entered(body):
	if body.is_in_group("player"):
		#print("player entered")
		in_combat = true


func _on_detection_area_2d_body_exited(body):
	if body.is_in_group("player"):
		#print("player exited")
		in_combat = false
