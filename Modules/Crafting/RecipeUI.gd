extends Control

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func assign_slots(width: int, height: int):
	for i in range(width):
		slots[i].slot_num = (width*(height-1)) + i

func update_ui(width: int):
	for i in range(width):
		pass
