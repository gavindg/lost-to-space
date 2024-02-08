extends Control

@onready var inv: Inventory = preload("res://inventory/test_inv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()


var is_open = false

func take_item(slot_num: int):
	inv.take_item(slot_num)
	update_slots()

func put_item(slot_num: int):
	inv.put_item(slot_num)
	update_slots()

func update_slots():
	for i in range(min(inv.inv.size(), slots.size())):
		slots[i].update(inv.inv[i])

func assign_slots():
	for i in range(min(inv.inv.size(), slots.size())):
		slots[i].slot_num = i;

func _ready():
	update_slots()
	assign_slots()
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
