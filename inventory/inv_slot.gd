extends Resource

class_name InvSlot

@export var item: Item
@export var amount: int

func take_item():
	if (amount > 0):
		amount -= 1

func put_item(num_items: int):
	amount += num_items
