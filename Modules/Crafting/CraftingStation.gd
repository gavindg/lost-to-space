extends Node2D
class_name CraftingStation
"""
Creates items based on recipes provided, using items inside of the players inventory.
Inventories are arrays.
"""

func can_craft(item: Item, inventory: Inventory) -> bool:
	"""
	
	"""
	var can_craft : = true
	for i in item.recipe:
		if not inventory.contains(i, item.recipe[i]):
			can_craft = false
	if item.recipe.is_empty() or not can_craft:
		can_craft = false
	return can_craft
	
func craft(item: Item, inventory: Inventory):
	print(inventory.contains(item, 1))
	if not can_craft(item, inventory):
		return
	else:
		for i in item.recipe:
			inventory.remove(i, item.recipe[i])
		inventory.insert(item, 1)
	print(inventory.contains(item, 1))
	
	
	
