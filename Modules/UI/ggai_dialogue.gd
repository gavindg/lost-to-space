extends Control

signal open_dialogue

var last_flag = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if last_flag != Globals.cur_flag:
		last_flag = Globals.cur_flag
		open_dialogue.emit(last_flag)
		
func _ready():
	await get_tree().create_timer(5).timeout
	open_dialogue.emit("intro_flag")
