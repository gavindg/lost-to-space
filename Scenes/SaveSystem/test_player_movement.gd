# based on https://github.com/godotengine/godot-demo-projects/blob/master/2d/kinematic_character/player/player.gd
# this is just test movement ... no hard feelings ?

extends CharacterBody2D

@export var walk_force = 1000
@export var max_speed = 400
@export var jump_velocity = 650
@export var stop_speed = 2000

@onready var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	var input_direction = walk_force * Input.get_axis("left", "right")
	
	# allows for slow stopping if we're slowing down...
	if abs(input_direction) < walk_force * 0.2:
		velocity.x = move_toward(velocity.x, 0, stop_speed * delta)
	else:
		velocity.x += input_direction * delta
	
	# clamps our x movement to our max speed in either dir
	velocity.x = clamp(velocity.x, -max_speed, max_speed) 
	
	# downward accel from gravity
	velocity.y += delta * GRAVITY
	
	move_and_slide()
	
	# is_on_floor() only works properly when called after movement code...
	if (is_on_floor() and Input.is_action_just_pressed("up")):
		velocity.y = -jump_velocity
		


