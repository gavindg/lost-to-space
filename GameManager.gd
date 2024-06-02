extends Node2D

@onready var pause_menu = $UI/PauseMenu
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.game_manager = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("Pause")):
		if(paused): #unpause
			unpause()
		else: #pause
			pause()

func unpause():
	paused = false
	pause_menu.visible = false
	get_tree().paused = false

func pause():
	paused = true
	pause_menu.visible = true
	get_tree().paused = true
