extends Node2D

@export var item: Item
@export var amount: int
@onready var item_sprite: Sprite2D = $Sprite2D
signal area_entered(area)

func _ready():
	item_sprite.texture = item.sprite



func _on_area_2d_area_entered(area: Area2D):
	if(area.get_parent().name == "Player"):
		area_entered.emit(self)
