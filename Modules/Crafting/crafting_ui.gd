extends Node2D

@onready var craft_container = $CraftingContainer/VCraftingContainer
@onready var recipe_ui = $RecipeContainer/RecipeUI
var craft_array = []


func set_crafting(inv: Inventory):
	visible = true
	recipe_ui._ready
	craft_container.initialize(craft_array, inv)
	

func create_item_arrays():
	var glue = load("res://Modules/Inventory/items/glue.tres")
	craft_array.append(glue)

