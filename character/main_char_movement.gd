extends CharacterBody2D

# basic movements: w/a/s/d to move up/left/down/right
# features: double junp - space; dash - shift;


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const double_jump_speed = -500
var dash_speed = 500

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# double-jump
var has_jumped = false
var has_double_jumped = false

# dash
var is_dashing = false
var has_dashed = false

# wall-jump
var can_wall_jump = false
var wall_jump_direction = 0

#special movement
var is_special_movement = false



func _physics_process(delta):
	
	# reset jump and double jump status
	if is_on_floor():
		has_jumped = false
		has_double_jumped = false
		has_dashed = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
		
	# handle collision
	if $left_RayCast2D.is_colliding():
		var collider = $left_RayCast2D.get_collider()
		if collider is TileMap && Input.is_action_pressed("left"):
			print("collide and move left")
			can_wall_jump = true
			wall_jump_direction = 1
			print("can_wall_jump ", can_wall_jump)
	#else:
		#can_wall_jump = false
		#print("can_wall_jump ", can_wall_jump)
		
	if is_special_movement == false:
		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			if can_wall_jump == true:
				wall_jump(wall_jump_direction)
			
			# if the character could jump for the first time
			elif !has_jumped && is_on_floor():
				velocity.y = JUMP_VELOCITY
				has_jumped = true
			# if not, check for availbility to jump again
			else:
				if !has_double_jumped:
					velocity.y = double_jump_speed
					has_double_jumped = true
				
		var direction = Input.get_axis("left", "right")
		# Handle dash
		if not is_special_movement:
			
			if not is_dashing:
				direction = Input.get_axis("left", "right")
				if direction:
					velocity.x = direction * SPEED
				else:
					velocity.x = move_toward(velocity.x, 0, SPEED)
			# do dash
			if Input.is_action_just_pressed("dash") && has_dashed == false:
				dash()
			
	print("before move and slide", velocity.x)
	move_and_slide()
	


# you can dash to one of the eight directions depending on which (one or two) keys you are holding
enum directions {
	up,
	up_right,
	right,
	down_right,
	down,
	down_left,
	left,
	up_left
}


# the character should be able to dash for a fixed distance for one of the 8 directions on the ground or in the air
# you can dash once before you land to the ground again
func dash():
	is_special_movement = true
	var x_direction = Input.get_axis("left", "right")
	var y_direction = Input.get_axis("up", "down")

	velocity.x = x_direction * dash_speed
	velocity.y = y_direction * dash_speed

	has_dashed = true
	is_dashing = true

	await get_tree().create_timer(0.25).timeout
	is_dashing = false
	is_special_movement = false




# the character should be able to kick the wall to jump to an opposite direction
func wall_jump(wall_jump_direction):
	is_special_movement = true
	if wall_jump_direction == 0:
		return
	print("Wall jump executed")
	print("velocity.x", velocity.x)
	velocity.x = wall_jump_direction * 700 
	print("velocity.x", velocity.x)
	velocity.y = -500
	await get_tree().create_timer(0.3).timeout
	is_special_movement = false
	can_wall_jump = false
