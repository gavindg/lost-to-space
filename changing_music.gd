extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	playing = false
	await get_tree().create_timer(1.0).timeout
	playing = true
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
