extends VBoxContainer

@onready var craft_station = $CraftingStation
@onready var recipe_ui = $"../../RecipeContainer/RecipeUI"
@onready var recipe_slots: Inventory = preload("res://Modules/Crafting/recipe_slots.tres")

func initialize(item_list: Array, inv: Inventory):
	visible = true
	clear_buttons()
	for item in item_list:
		var button = Button.new()
		button.text = item.name
		var sprite_button = TextureButton.new()
		sprite_button.texture_normal = item.sprite
		button.add_child(sprite_button)
		button.connect("pressed", craft_station.craft.bind(item, inv))
		button.connect("mouse_entered", add_to_recipe_ui.bind(item))
		button.connect("mouse_exited", clear_recipe_ui.bind(item))
		add_child(button)
		
func clear_buttons():
	for child in get_children():
		remove_child(child)
		
func add_to_recipe_ui(item: Item):
	for i in item.recipe:
		recipe_slots.insert(i, item.recipe[i])
	recipe_ui.update_ui()
	
	
	
func clear_recipe_ui(item: Item):
	for i in item.recipe:
		recipe_slots.remove(i, item.recipe[i])
	recipe_ui.update_ui()
	
