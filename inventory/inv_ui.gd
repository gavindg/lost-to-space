extends Control

@onready var inv: Inventory = preload("res://inventory/test_inv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()


var is_open = false

func update_slots():
	for i in range(min(inv.inv.size(), slots.size())):
		slots[i].update_item(inv.inv[i])

func _ready():
	update_slots()
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
