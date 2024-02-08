extends Panel

@onready var item_sprite: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_text: Label = $CenterContainer/Panel/Label
@onready var inv_ui = self.find_parent("Inv_UI")

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass

func _process(delta):
	global_position = get_viewport().get_mouse_position() - get_canvas_transform().origin
