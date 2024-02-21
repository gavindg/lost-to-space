extends RigidBody2D

var velocity = Vector2()
@export var speed = 50 #speed of slime
var wander_timer = 0.0; # internal timer for wander
@export var min_wander_interval = 1 # min time in seconds that the slime will wander in one direction
@export var max_wander_interval = 2 # max time in seconds that the slime will wander in one direction
@export var gravity_strength = 10
var is_jumping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += gravity_strength * delta
	wander_timer -= delta;
	wander()
	move_and_collide(velocity)
		

# the wander function of the slime
func wander():
	# if the wander timer is run down, choose a random direction and move by it. 
	if wander_timer <= 0.0 && !is_jumping:
		is_jumping = true;
		var random_x = randf_range(-1.0, 1.0)
		var random_direction = Vector2(random_x, 0).normalized()
		
		velocity.y = -speed * cos(deg_to_rad(45)) 
		velocity.x = speed * sin(deg_to_rad(45))
		
		var wander_interval = randf_range(min_wander_interval, max_wander_interval)
		
		wander_timer = wander_interval
	else:
		is_jumping = false;
