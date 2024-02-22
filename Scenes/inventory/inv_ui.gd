extends Control

@onready var inv: Inventory = preload("res://Scenes/inventory/test_inv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var cursor = $cursor_item

var is_open = false

func update_ui():
	for i in range(min(inv.inv.size(), slots.size())):
		slots[i].update(inv.inv[i])

func assign_slots(inv_size: int):
	for i in range(inv_size):
		slots[i].slot_num = i

func _ready():
	update_ui()
	close()

func _process(delta):
	if Input.is_action_just_pressed("e"):
		if is_open:
			close()
		else: 
			open()


func close():
	visible = false
	is_open = false

func open():
	visible = true
	is_open = true
