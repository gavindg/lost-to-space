extends RichTextLabel

var speed = 60
var tick = 0
var initspeed = 60

var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
	position.y -= speed * delta
