extends Control

@export var player: CharacterBody2D

@onready var inv: Inventory = preload("res://Modules/Inventory/test_inv.tres")
@onready var inv_ui = $Inv_UI
@onready var hotbar_ui = $Hotbar_UI
@onready var cursor = $cursor_item
@onready var select_slots = $Hotbar_UI/Select_UI.get_children()
@onready var width = 10
@onready var height = 4
@onready var dropped_item_scene = preload("res://Modules/Inventory/dropped_item.tscn")
@onready var is_open = false
@onready var hotbar_slot: int = 0

@onready var holding: bool  = false #whether there is an item in the cursor slot
@onready var mouse_in_inv: bool = false #whether mouse hovering over the inventory

func check_holding():
	if(inv.cursor_slot.item == null):
		holding = false
	else:
		holding = true

func left(slot_num: int):
	if(is_open):
		inv.left(slot_num)
		check_holding()
		update_ui()
	else:
		hotbar_slot = slot_num - (width * (height-1))
		update_ui()

func right(slot_num: int):
	if(is_open):
		inv.right(slot_num)
		if(inv.cursor_slot.item == null):
			holding = false
		else:
			holding = true
		update_ui()

func update_ui():
	inv_ui.update_ui()
	hotbar_ui.update_ui(width)
	update_cursor()
	update_select()

func update_cursor():
	cursor.update_ui(inv.cursor_slot)

func update_select():
	for i in range(width):
		if(i == hotbar_slot):
			select_slots[i].modulate = Color(1,1,1,1)
		else:
			select_slots[i].modulate = Color(1,1,1,0)

func assign_slots():
	inv_ui.assign_slots(width*(height-1))
	hotbar_ui.assign_slots(width,height)

func _ready():
	assign_slots()
	update_ui()

func _process(_delta):
	check_toggle_inv()
	check_in_inv()
	check_drop()

func check_toggle_inv():
	if Input.is_action_just_pressed("e"):
		if is_open:
			is_open = false
			if(inv.cursor_slot.item != null):
				var left_over = inv.insert(inv.cursor_slot.item, inv.cursor_slot.amount)
				if(left_over != 0):
					inv.cursor_slot.amount = left_over
					create_dropped_item(inv.cursor_slot).position = player.position
				inv.cursor_slot.clear()
				update_ui()
			inv_ui.close()
		else: 
			is_open = true
			inv_ui.open()

func check_in_inv():
	if(is_open):
		if(inv_ui.get_global_rect().has_point(get_global_mouse_position()) or hotbar_ui.get_global_rect().has_point(get_global_mouse_position())):
			mouse_in_inv = true
		else:
			mouse_in_inv = false

func check_drop():
	if(inv.cursor_slot.item != null and !mouse_in_inv and Input.is_action_just_pressed("right_mouse")):
		create_dropped_item(inv.cursor_slot).position = get_global_mouse_position()

func create_dropped_item(slot: InvSlot):
	var instance = dropped_item_scene.instantiate()
	instance.item = slot.item
	instance.amount = slot.amount
	instance.area_entered.connect(_on_dropped_item_area_entered)
	slot.clear()
	update_ui()
	get_parent().get_parent().add_child(instance)
	return instance

func _on_dropped_item_area_entered(dropped_item):
	var remaining = inv.insert(dropped_item.item, dropped_item.amount)
	update_ui()
	if(remaining != 0):
		dropped_item.amount = remaining
	else:
		dropped_item.queue_free()

func test_button():
	if Input.is_action_just_pressed("test_func"):
		print(inv.remove(load("res://Scenes/inventory/items/dirt.tres"),10))
		update_ui()
