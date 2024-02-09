extends Panel

@onready var item_sprite: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_text: Label = $CenterContainer/Panel/Label
@onready var inv_ui = self.find_parent("Inv_UI")
@onready var slot_num: int
@onready var button: Button = $Button

func _ready():
	button.pressed.connect(self._button_pressed)

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

func _button_pressed():
	if(Input.is_action_just_pressed("right")):
		inv_ui.right(slot_num)
	elif(Input.is_action_just_pressed("left")):
		inv_ui.left(slot_num)
