extends Node2D

	# Assume you've named your AudioStreamPlayer nodes as 'Song1' and 'Song2'
func _ready():
	var song1 = $Song1
	#song1.connect("finished", song1, "_on_Song1_finished")
	song1.play()

func _on_Song1_finished():
	$Song2.play()
