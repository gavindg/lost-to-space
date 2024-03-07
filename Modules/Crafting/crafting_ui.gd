extends Node2D

@onready var craft_container = $CraftingContainer/VCraftingContainer
var craft_array = []


func set_crafting(inv: Inventory):
	craft_container.initialize(craft_array, inv)

func create_item_arrays():
	var glue = load("res://Modules/Inventory/items/glue.tres")
	craft_array.append(glue)

