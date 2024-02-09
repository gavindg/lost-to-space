extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -600.0
const double_jump_speed = -600

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var has_jumped = false
var has_double_jumped = false



func _physics_process(delta):
	
	# reset jump and double jump status
	if is_on_floor():
		has_jumped = false
		has_double_jumped = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		# if the character could jump for the first time
		if !has_jumped:
			velocity.y = JUMP_VELOCITY
			has_jumped = true
		# if not, check for availbility to jump again
		else:
			if !has_double_jumped:
				velocity.y = double_jump_speed
				has_double_jumped = true
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
