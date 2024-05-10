extends Node

var swinging: bool = false
var swing_time: float = 0.25
var start_angle: float = 70
var stop_angle: float = -20 
var angle: float = 70
var length: float = 100


@onready var RayCast = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("attack") and !swinging:
		swinging = true
	
	if swinging:
		RayCast.target_position = Vector2(length*cos(deg_to_rad(angle)),-length*sin(deg_to_rad(angle)))
		RayCast.get_collider()
		angle -= (delta/swing_time)*(start_angle-stop_angle)
		if(angle < stop_angle):
			swinging = false
			angle = start_angle
			RayCast.get_collider()
		
		
		
