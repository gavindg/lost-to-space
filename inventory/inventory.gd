extends Resource

class_name Inventory

@export var inv: Array[InvSlot]

func take_item(slot_num: int):
	inv[slot_num].take_item()

func put_item(slot_num: int):
	inv[slot_num].put_item(1)

func insert(item: Item):
	pass
