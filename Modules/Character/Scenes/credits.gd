extends Node2D

@onready var credit_content = $RichTextLabel
@onready var black_box = $Sprite2D

var speed = 60
var tick = 0
var initspeed = 60

var counter = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	var res = get_viewport().size
	print(res)
	credit_content.position.x = res.x / 2 - (credit_content.size.x / 2)
	credit_content.position.y = res.y
	black_box.position.x = res.x / 2
	black_box.position.y = 0
	black_box.scale.y = res.y * 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if counter <= 300:
		speed = 0
	else:
		speed = initspeed
	
	counter += initspeed * delta
		
	if tick >= 7000:
		speed = initspeed - 2
		
	if tick >= 8000:
		speed = initspeed - 5
		
	if tick >= 9000:
		speed = initspeed - 8
		
	if tick >= 10000:
		speed = initspeed - 12
	
	tick+=speed*delta
	credit_content.position.y -= speed * delta
