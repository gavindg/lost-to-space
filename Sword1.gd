extends Node2D

var angle = 0
@export var player : CharacterBody2D
var offset = deg_to_rad(angle)
var speed = 12  # Adjust this value to change rotation speed
var px = 200
var py = 100
var newx = 0
var newy = 0
var tick = 0
var tickrads = 0

func _physics_process(delta):
	
	if Input.is_action_pressed("attack"):
		self.visible = true
		print("tru1")
	else:
	# Hide the sprite when the key is not pressed.
		self.visible = false
	
	tick += speed
	if tick == 2881:
		tick = 0
	tickrads = deg_to_rad(tick)
	
	newx = 75*sin(tickrads)*cos(offset)-15*cos(tickrads)*sin(offset)
	newy = 75*sin(tickrads)*sin(offset)+15*cos(tickrads)*cos(offset)
	
	px = player.position.x
	py = player.position.y
	
	rotation_degrees = tick - angle - 225
	
	self.position.x = px - newx 
	self.position.y = py + newy
