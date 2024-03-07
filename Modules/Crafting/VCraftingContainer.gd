extends VBoxContainer

@onready var craft_station = $CraftingStation

func initialize(item_list: Array, inv: Inventory):
	clear_buttons()
	for item in item_list:
		var button = Button.new()
		button.text = item.name
		var sprite_button = TextureButton.new()
		sprite_button.texture_normal = item.sprite
		button.add_child(sprite_button)
		button.connect("pressed", craft_station.craft.bind(item, inv))
		add_child(button)
		
func clear_buttons():
	for child in get_children():
		remove_child(child)
