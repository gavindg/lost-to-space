extends Control

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var recipe_menu = preload("res://Modules/Crafting/recipe_slots.tres")
			
func update_ui():
	for i in range(min(recipe_menu.inv.size(), slots.size())):
		slots[i].update(recipe_menu.inv[i])

func assign_slots(inv_size: int):
	for i in range(inv_size):
		slots[i].slot_num = i

func _ready():
	update_ui()
	open()

func open():
	visible = true
