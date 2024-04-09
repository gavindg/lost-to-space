extends CharacterBody2D

# player reference
@export var player : CharacterBody2D = null

# movement variables
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const vert_jump_max = 800
const vert_jump_min = 500
const horiz_jump_min = 200
const horiz_jump_max = 400
var dir : float = 0
var just_jumped = false
var hit_a_wall = false


# range that the slime might wait in between jumping (in seconds)
const MIN_WAIT : float = 0.75
const MAX_WAIT : float = 2.5
@onready var wait_time : float = 0

# current state
@onready var state_action = "jumping"


func _ready():
	print("player exists: ", player != null)
	print("starting")


func _physics_process(delta):
	# state action
	call(state_action, delta)
	print("current state: ", state_action)
	
	# process gravity 
	velocity.y += gravity * delta
	move_and_slide()
	
	if is_on_wall():
		hit_a_wall = true
	

# state: not touching a wall; jump towards player like normal
func aggro(_delta):
	dir = 1 if player.global_position.direction_to(global_position).x > 0 else -1
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
func waiting(delta):
	wait_time -= delta
	if wait_time < 0 and is_on_floor():
		# wait is over
		state_action = "touching_wall" if hit_a_wall else "aggro"


# state: does the frame-by-frame physics processing of the jump 
func jumping(delta):
	if !just_jumped and is_on_floor():
		velocity = Vector2.ZERO
		wait_time = randf_range(MIN_WAIT, MAX_WAIT)
		state_action = "waiting"
		return
	
	just_jumped = false


# adds instantaneous velocity to make bro yump
func jump():
	var horiz_vel = randi() % (horiz_jump_max - horiz_jump_min) + horiz_jump_min
	var vert_vel = randi() % (vert_jump_max - vert_jump_min) + vert_jump_min
	
	velocity = (dir * Vector2.RIGHT * horiz_vel) + (up_direction * vert_vel)
	#print("set velocity to ", velocity)
	just_jumped = true
