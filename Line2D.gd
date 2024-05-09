extends Line2D
class_name Trails
 
var queue : Array
@export var MAX_LENGTH : int
@export var sword : Sprite2D
 
func _process(_delta):
	var pos = _get_position()
 
	if Input.is_action_pressed("attack"):
		self.visible = true
	else:
		# Hide the sprite when the key is not pressed.
		self.visible = false

	queue.push_front(pos)
 
	if queue.size() > MAX_LENGTH:
		queue.pop_back()
 
	clear_points()
 
 
	for point in queue:
		add_point(point)
 
func _get_position():
	return sword.position
