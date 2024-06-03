extends Node2D

@onready var pause_menu = $UI/PauseMenu
@onready var player_cam = $SceneObjects/Michael/INSANELYSCUFFED
var paused = false

var loading_screen = preload("res://Modules/Cutscenes/loadingscreen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():	
	var instance = loading_screen.instantiate()
	player_cam.add_child(instance)
	instance.position = Vector2i(0,48)
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
