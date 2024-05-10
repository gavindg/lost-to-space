extends Node

var swinging: bool = false
var swing_time_left: int = 0
var angle: int = 45
var length: float = 100

@onready var RayCast = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("attack") and !swinging:
		print(cos(deg_to_rad(angle)))
		swinging = true
	
	if swinging:
		RayCast.target_position = Vector2(length*cos(deg_to_rad(angle)),-length*sin(deg_to_rad(angle)))
		RayCast.get_collider()
		
