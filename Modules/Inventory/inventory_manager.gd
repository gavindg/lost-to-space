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
@onready var held_item: Item

@onready var dirt: Item = preload("res://Modules/Inventory/items/dirt.tres")
@onready var ore: Item = preload("res://Modules/Inventory/items/ore.tres")

@onready var holding: bool  = false #whether there is an item in the cursor slot
@onready var mouse_in_inv: bool = false #whether mouse hovering over the inventory

func check_holding():
	if(inv.cursor_slot.item == null):
		holding = false
	else:
		holding = true

func check_select_type():
	held_item = inv.inv[30+hotbar_slot].item

func left(slot_num: int):
	if(is_open):
		inv.left(slot_num)
		check_select_type()
		check_holding()
		update_ui()
	else:
		hotbar_slot = slot_num - (width * (height-1))
		check_select_type()
		update_ui()

func right(slot_num: int):
	if(is_open):
		inv.right(slot_num)
		check_select_type()
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
	check_select_type()

func assign_slots():
	inv_ui.assign_slots(width*(height-1))
	hotbar_ui.assign_slots(width,height)

func _ready():
	Globals.inv_manager = self
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
				check_select_type()
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

func give_dirt():
	inv.insert(dirt,1)
	update_ui()

func give_ore():
	inv.insert(ore,1)
	update_ui()

func remove_dirt():
	var success = inv.remove(dirt,1)
	update_ui()
	return success

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_WHEEL_DOWN:
		hotbar_slot += 1
		if(hotbar_slot >= 10):
			hotbar_slot -= 10
		update_select()
	elif event is InputEventMouseButton and event.pressed and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_WHEEL_UP:
		hotbar_slot -= 1
		if(hotbar_slot < 0):
			hotbar_slot += 10
		update_select()
	elif event is InputEventKey and event.pressed and 48 <= (event as InputEventKey).keycode and (event as InputEventKey).keycode <= 57:
		hotbar_slot = posmod(((event as InputEventKey).keycode - 49),10)
		update_select()

func handle_use():
	if(mouse_in_inv):
		return
	if held_item is Useless:
		return
	elif held_item is Placeable:
		place()
	elif held_item is Consumable:
		consume()
	elif held_item is Tool:
		use_tool()
	elif held_item is Weapon:
		use_weapon()

func place():
	pass

func consume():
	var stats = Globals.player.stats
	print(stats.hp)
	stats.hp += held_item.healing
	stats.hp -= held_item.damage
	print(stats.hp)
	

func use_tool():
	pass

func use_weapon():
	pass
