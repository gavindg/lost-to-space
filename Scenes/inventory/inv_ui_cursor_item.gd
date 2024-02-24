extends Panel

@onready var item_sprite: Sprite2D = $sprite_display
@onready var amount_text: Label = $Label

func _ready():
	pass

func update_ui(slot: InvSlot):
	if(!slot.item):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		item_sprite.visible = false
		amount_text.visible = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		item_sprite.visible = true
		item_sprite.texture = slot.item.sprite
		if(slot.amount > 1):
			amount_text.text = str(slot.amount)
			amount_text.visible = true
		else:
			amount_text.visible = false

func _process(delta):
	global_position = get_global_mouse_position()
