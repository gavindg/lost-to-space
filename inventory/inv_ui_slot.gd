extends Panel

@onready var item_sprite: Sprite2D = $item_display

func update_item(item: Item):
	if(!item):
		item_sprite.visible = false
	else:
		item_sprite.visible = true
		item_sprite.texture = item.sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
