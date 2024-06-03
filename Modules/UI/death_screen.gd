extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.death_ui = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_restart_pressed():
	Globals.unpause()
	get_tree().change_scene_to_file("res://playtesting.tscn")


func _on_quit_pressed():
	get_tree().quit()
