extends Control

@export var player: CharacterBody2D

@onready var craft_ui = $Crafting_UI

# Called when the node enters the scene tree for the first time.
func _ready():
	craft_ui.create_item_arrays()
	craft_ui.set_crafting(player.inv)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


