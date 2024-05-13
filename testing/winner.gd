extends Node2D

# most scuffed script in the universe

@export var audio : AudioStreamPlayer
@export var text : RichTextLabel
@export var tween_speed := .5

func _ready():
	if not audio: 
		audio = $PVZ
	
	if audio and text:
		text.modulate.a = 0
		audio.play()
		var tween = get_tree().create_tween()
		await tween.tween_property(text, "modulate:a", 
									1, tween_speed).finished
		
		await audio.finished
		tween = get_tree().create_tween()
		await tween.tween_property(text, "modulate:a", 
									0, tween_speed).finished
		queue_free()
	else:
		print('ERROR: audio not found...')
		queue_free()
