extends Panel

@onready var item_sprite: Sprite2D = $CenterContainer/Panel/Item
@onready var amount_text: Label = $CenterContainer/Panel/Label



func update(slot: InvSlot):
	if(!slot.item):
		item_sprite.visible = false
		amount_text.visible = false
	else:
		item_sprite.visible = true
		item_sprite.texture = slot.item.sprite
		if(slot.amount > 1):
			amount_text.text = str(slot.amount)
			amount_text.visible = true
		else:
			amount_text.visible = false
