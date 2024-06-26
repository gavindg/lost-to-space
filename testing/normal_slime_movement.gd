extends CharacterBody2D

# player reference ## TODO: change this to a global reference eventually
@export var player : CharacterBody2D = Globals.player
var valid = true  # false if no player is found

# movement variables
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

## max vertical height the slime can jump (MUST BE > THE MIN)
@export var vert_jump_max = 200
## min vertical height the slime can jump (MUST BE < THE MAX)
@export var vert_jump_min = 100
## asbsolute fastest yump the slmie can speed (MUST BE > THE MIN)
@export var horiz_jump_max = 300
## min horizontal height that the slime can jump (MUST BE < THE MAX)
@export var horiz_jump_min = 150
## slow it up yuh
@export var slowdown_speed = 800
var dir : float = 0
var just_jumped = false
var hit_a_wall = false

# range that the slime might wait in between jumping (in seconds)
@export var MIN_WAIT : float = 0.75
@export var MAX_WAIT : float = 2
@onready var wait_time : float = 0
@onready var speed_mod := 1

# current state
@onready var state_action = "aggro"

# animation handler
#@onready var anim_handler : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D

@onready var combatman = $CombatHandler

func _ready():
	# get player object
	if not sprite:
		valid = false
		print('cooked')
		return
	if player != null:  # default is the exported player object
		return
	if Globals.player != null:  # then the global player ref
		player = Globals.player
		return
	valid = false  # otherwise we are cooked


@onready var dead = false

## MOVEMENT ##

func _physics_process(delta):
	if dead: return
	
	if combatman.is_dead == true:
		dead = true
		die()
	
	# debug: stop if no player is found
	if !valid: return
	
	# state action
	call(state_action, delta)  # some states need delta
	
	# always process gravity 
	velocity.y += gravity * delta
	move_and_slide()
	
	# should be callsed after move&slide
	if is_on_wall():
		hit_a_wall = true


# state: not touching a wall; jump towards player
# in this state the slime decides what it will do next; jump or dash
func aggro(_delta):
	dir = 1 if global_position.x < player.global_position.x else -1
	sprite.flip_h = 0 if dir == -1 else 1
	speed_mod = 1
	
	jump()
	state_action = "jumping"


# state: touching a wall; needs to jump away from the wall
# essentially the same as aggro, but the slime will always jump away
# from the wall it touched, even if its away from the player.
func touching_wall(_delta):
	dir = get_wall_normal().x
	sprite.flip_h = 0 if dir == -1 else 1
	speed_mod = 0.5
	
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


# adds instantaneous velocity to make bro yump
func jump():
	var horiz_vel = randi() % (horiz_jump_max - horiz_jump_min) + horiz_jump_min
	var vert_vel = vert_jump_max if randi() % 2 == 0 else vert_jump_min
	
	velocity = speed_mod * ((dir * Vector2.RIGHT * horiz_vel) + (up_direction * vert_vel))
	just_jumped = true
	

### ON DEATH ###

func die():
	combatman.die() # queue free that sucka
