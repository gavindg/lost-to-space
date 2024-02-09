extends Resource

class_name InvSlot

@export var item: Item
@export var amount: int
@export var MAX_AMOUNT: int = 100

func add(add_amount: int):
	amount += add_amount
	if(amount > MAX_AMOUNT):
		var left_over: int = amount - MAX_AMOUNT
		amount = MAX_AMOUNT
		return left_over
	else:
		return 0

func swap(swap_item: Item, swap_amount: int):
	item = swap_item
	var ret_amount: int = amount
	amount = swap_amount
	if(amount == 0):
		item = null
	return ret_amount

func take_half():
	var old_amount: int = amount
	amount /= 2
	if(amount == 0):
		item = null
	return old_amount - amount

