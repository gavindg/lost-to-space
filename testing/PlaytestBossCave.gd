extends Node2D

@onready var player_cam = $Michael/INSANELYSCUFFED
var loading_screen = preload("res://Modules/Cutscenes/loadingscreen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var instance = loading_screen.instantiate()
	player_cam.add_child(instance)
	instance.position = Vector2i(0, 48)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
