extends Control

@onready var inv: Inventory = preload("res://Scenes/inventory/test_inv.tres")
@onready var inv_ui = $Inv_UI
@onready var hotbar_ui = $Hotbar_UI
@onready var cursor = $cursor_item
@onready var width = 10
@onready var height = 4

var is_open = false

func left(slot_num: int):
	inv.left(slot_num)
	update_ui()

func right(slot_num: int):
	inv.right(slot_num)
	update_ui()

func update_ui():
	inv_ui.update_ui()
	hotbar_ui.update_ui(width)
	update_cursor()

func update_cursor():
	cursor.update_ui(inv.cursor_slot)

func assign_slots():
	inv_ui.assign_slots(width*(height-1))
	hotbar_ui.assign_slots(width,height)

func _ready():
	assign_slots()
	update_ui()
