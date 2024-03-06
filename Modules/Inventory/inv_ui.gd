extends Control

@onready var inv: Inventory = preload("res://Modules/Inventory/test_inv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var cursor = $cursor_item


func update_ui():
	for i in range(min(inv.inv.size(), slots.size())):
		slots[i].update(inv.inv[i])

func assign_slots(inv_size: int):
	for i in range(inv_size):
		slots[i].slot_num = i

func _ready():
	update_ui()
	close()

func close():
	visible = false

func open():
	visible = true
