extends Resource

class_name Inventory

@export var inv: Array[InvSlot]
@export var cursor_slot: InvSlot

func left(slot_num: int):
	var item: Item = inv[slot_num].item
	var cursor_item: Item = cursor_slot.item
	var new_amount: int = 0;
	match [item != null,cursor_item != null, item == cursor_item]:
		[true,true,true]:
			new_amount = inv[slot_num].add(cursor_slot.amount)
			cursor_slot.amount = new_amount
			if(cursor_slot.amount == 0):
				cursor_slot.item = null
		[true,true,false]:
			new_amount = inv[slot_num].swap(cursor_item,cursor_slot.amount)
			cursor_slot.item = item
			cursor_slot.amount = new_amount
			if(cursor_slot.amount == 0):
				cursor_slot.item = null
		[true,false,_]:
			new_amount = inv[slot_num].swap(cursor_item,0)
			cursor_slot.item = item
			cursor_slot.amount = new_amount
			if(cursor_slot.amount == 0):
				cursor_slot.item = null
		[false,true,_]:
			new_amount = inv[slot_num].swap(cursor_item,cursor_slot.amount)
			cursor_slot.item = item
			cursor_slot.amount = 0
			cursor_slot.item = null

func right(slot_num: int):
	var item: Item = inv[slot_num].item
	var cursor_item: Item = cursor_slot.item
	var new_amount: int = 0;
	match [item != null,cursor_item != null, item == cursor_item]:
		[true,true,true]:
			new_amount = inv[slot_num].add(1)
			if(new_amount == 0):
				cursor_slot.amount -= 1
				if(cursor_slot.amount == 0):
					cursor_slot.item = null
		[true,false,_]:
			new_amount = inv[slot_num].take_half()
			cursor_slot.item = item
			cursor_slot.amount = new_amount
			if(cursor_slot.amount == 0):
				cursor_slot.item = null
		[false,true,_]:
			inv[slot_num].item = cursor_item
			inv[slot_num].amount = 1
			cursor_slot.amount -= 1
			if(cursor_slot.amount == 0):
				cursor_slot.item = null

func insert(item: Item):
	pass
