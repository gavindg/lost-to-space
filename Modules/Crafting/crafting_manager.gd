extends Control

@onready var craft_ui = $Crafting_UI
@onready var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	craft_ui.create_item_arrays()
	craft_ui.set_crafting(Globals.inv_manager.inv)
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_toggle_craft()
	
func check_toggle_craft():
	if Input.is_action_just_pressed("e"):
		if is_open:
			is_open = false
			visible = false
		else: 
			is_open = true
			visible = true


