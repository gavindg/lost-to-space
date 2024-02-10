extends Control

@onready var inv: Inventory = preload("res://Scenes/inventory/test_inv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var cursor = $cursor_item


var is_open = false

func left(slot_num: int):
	inv.left(slot_num)
	update_slots()
	update_cursor()

func right(slot_num: int):
	inv.right(slot_num)
	update_slots()
	update_cursor()

func update_slots():
	for i in range(min(inv.inv.size(), slots.size())):
		slots[i].update(inv.inv[i])

func update_cursor():
	cursor.update(inv.cursor_slot)

func assign_slots():
	for i in range(min(inv.inv.size(), slots.size())):
		slots[i].slot_num = i;

func _ready():
	assign_slots()
	update_slots()
	update_cursor()
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
