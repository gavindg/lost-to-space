extends Node

var A = AudioServer.get_bus_index("fadein")
var B = AudioServer.get_bus_index("fadeout")

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_change(10)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer.time_left>0:
		print(timer.time_left)
		audio_swap()
		

func audio_swap():
	AudioServer.set_bus_volume_db(A,AudioServer.get_bus_volume_db(A)-1)
	AudioServer.set_bus_volume_db(B,AudioServer.get_bus_volume_db(B)-1)
		

var timer : SceneTreeTimer
	
func audio_change(fadein):
	#10 seconds
	timer = get_tree().create_timer(fadein)
	await timer.timeout
