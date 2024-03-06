extends Resource

class_name Inventory

@export var inv: Array[InvSlot]
@export var cursor_slot: InvSlot
@export var width: int
@export var height: int

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

func insert(item: Item, amount: int):
	#check if already in inventory
	var remaining:int = amount
	for i in range((width*(height-1)),width*height):
		if(inv[i].item == item):
			remaining = inv[i].add(remaining)
			if(remaining == 0):
				return remaining
	for i in range(width*(height-1)):
		if(inv[i].item == item):
			remaining = inv[i].add(remaining)
			if(remaining == 0):
				return remaining
	#if not in inventory, put in empty slots
	for i in range((width*(height-1)),width*height):
		if(inv[i].item == null):
			remaining = inv[i].put(item,remaining)
			if(remaining == 0):
				return remaining
	for i in range(width*(height-1)):
		if(inv[i].item == null):
			remaining = inv[i].put(item,remaining)
			if(remaining == 0):
				return remaining
	return remaining

func remove(item: Item, amount: int):
	if(!contains(item,amount)):
		return false
	var remove_remaining = amount
	for i in range((width*(height-1)),width*height):
		if(inv[i].item == item):
			if(inv[i].amount >= remove_remaining):
				inv[i].amount -= remove_remaining
				if(inv[i].amount == 0):
					inv[i].clear()
				remove_remaining = 0
			else:
				remove_remaining -= inv[i].amount
				inv[i].clear()
		if(remove_remaining == 0):
			return true
	for i in range(width*(height-1)):
		if(inv[i].item == item):
			if(inv[i].amount >= remove_remaining):
				inv[i].amount -= remove_remaining
				if(inv[i].amount == 0):
					inv[i].clear()
				remove_remaining = 0
			else:
				remove_remaining -= inv[i].amount
				inv[i].clear()
		if(remove_remaining == 0):
			return true

func contains(item: Item, amount: int):
	var amount_has: int = 0
	for i in range(inv.size()):
		if(inv[i].item == item):
			amount_has += inv[i].amount
	return amount_has >= amount
