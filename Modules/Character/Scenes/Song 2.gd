extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
# Assume you've named your AudioStreamPlayer nodes as 'Song1' and 'Song2'
func _ready():
	# Connect the 'finished' signal from the first song to a method in this script
	$Song1.connect("finished", self, "_on_Song1_finished")
	# Play the first song
	$Song1.play()

func _on_Song1_finished():
	# This method gets called when the first song finishes. Play the second song.
	$Song2.play()
