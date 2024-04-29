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
	if not can_craft(item, inventory):
		return
	else:
		for i in item.recipe:
			Globals.inv_manager.remove_item(i, item.recipe[i])
		Globals.inv_manager.insert_item(item, 1)
	
	
	
