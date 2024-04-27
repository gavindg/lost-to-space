extends CharacterBody2D

# player reference
@export var player : CharacterBody2D = null
var valid = true  # false if no player is found

# movement variables
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

## max vertical height the slime can jump
@export var vert_jump_max = 800
## min vertical height the slime can jump
@export var vert_jump_min = 400
## asbsolute fastest yump the slmie can speed
@export var horiz_jump_max = 400
## min horizontal height that the slime can jump
@export var horiz_jump_min = 200
## how fast man go speed mode
@export var dash_speed = 1000
## slow it up yuh
@export var slowdown_speed = 800
var dir : float = 0
var just_jumped = false
var hit_a_wall = false


# range that the slime might wait in between jumping (in seconds)
@export var MIN_WAIT : float = 0.75
@export var MAX_WAIT : float = 2.5
@onready var wait_time : float = 0

# current state
@onready var state_action = "jumping"


func _ready():
	if player == null:
		print("Player not found")
		valid = false


func _physics_process(delta):
	# debug: stop if no player is found
	if !valid: return
	
	# state action
	call(state_action, delta)  # some states need delta
	
	# process gravity 
	velocity.y += gravity * delta
	move_and_slide()
	
	if is_on_wall():
		hit_a_wall = true


# state: not touching a wall; jump towards player like normal
# basically, in this state the slime decides what it will do next
func aggro(_delta):
	dir = 1 if player.global_position.direction_to(global_position).x > 0 else -1
	if randi() % 3 == 1:
		dash()
		state_action = "dashing"
	else:
		jump()
		state_action = "jumping"


# state: touching a wall; needs to jump away from the wall
# TODO: test me !
func touching_wall(_delta):
	dir = get_wall_normal().x

	jump()
	state_action = "jumping"
	hit_a_wall = false


# state: pausing in between jumps
func on_cooldown(delta):
	wait_time -= delta
	# slow the slime down if it hasn't come to a stop yet
	velocity.x = move_toward(velocity.x, 0, slowdown_speed * delta)
	if wait_time < 0 and is_on_floor():
		# wait is over
		state_action = "touching_wall" if hit_a_wall else "aggro"


# state: does the frame-by-frame physics processing of the jump 
func jumping(delta):
	if !just_jumped and is_on_floor():
		velocity.y = 0
		wait_time = randf_range(MIN_WAIT, MAX_WAIT)
		state_action = "on_cooldown"
		return
	just_jumped = false

func dashing(delta):
	if !just_jumped and is_on_floor():
		velocity.y = 0
		wait_time = randf_range(MIN_WAIT, MAX_WAIT)
		state_action = "on_cooldown"
		return
	just_jumped = false

# adds instantaneous velocity to make bro yump
func jump():
	var horiz_vel = randi() % (horiz_jump_max - horiz_jump_min) + horiz_jump_min
	# var vert_vel = randi() % (vert_jump_max - vert_jump_min) + vert_jump_min
	var vert_vel = vert_jump_max if randi() % 2 == 0 else vert_jump_min
	
	velocity = (dir * Vector2.RIGHT * horiz_vel) + (up_direction * vert_vel)
	just_jumped = true


func dash():
	print("dashing")
	var horiz_vel = dash_speed
	var vert_vel = vert_jump_min / 2
	
	velocity = (dir * Vector2.RIGHT * horiz_vel) + (up_direction * vert_vel)
	just_jumped = true
