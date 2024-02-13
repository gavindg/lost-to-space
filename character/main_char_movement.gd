extends CharacterBody2D

# basic movements: w/a/s/d to move up/left/down/right
# features: double junp - space; dash - shift;


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const double_jump_speed = -500

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var has_jumped = false
var has_double_jumped = false
var is_dashing = false



func _physics_process(delta):
	
	# reset jump and double jump status
	if is_on_floor():
		has_jumped = false
		has_double_jumped = false
		has_dashed = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		# if the character could jump for the first time
		if !has_jumped && is_on_floor():
			velocity.y = JUMP_VELOCITY
			has_jumped = true
		# if not, check for availbility to jump again
		else:
			if !has_double_jumped:
				velocity.y = double_jump_speed
				has_double_jumped = true
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
		
	# Handle dash
	if not is_dashing:
		direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("dash") && has_dashed == false:
		dash()
		
	move_and_slide()
	

		
	
	


var dash_speed = 500
var has_dashed = false
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
	var x_direction = Input.get_axis("left", "right")
	var y_direction = Input.get_axis("up", "down")

	velocity.x = x_direction * dash_speed
	velocity.y = y_direction * dash_speed

	has_dashed = true
	is_dashing = true

	await get_tree().create_timer(0.2).timeout
	is_dashing = false
	

