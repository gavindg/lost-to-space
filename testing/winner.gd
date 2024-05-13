extends Node2D

# most scuffed script in the universe

@export var audio : AudioStreamPlayer

func _ready():
	if not audio: 
		audio = $PVZ
	
	if audio:
		audio.play()
		await audio.finished
		queue_free()
	else:
		print('ERROR: audio not found...')
		queue_free()
