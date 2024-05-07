extends Node2D

@export var sprite : Sprite2D = null
@export var dur = 1
@export var waittime = 3


func _ready() -> void:
	print('ready')
	sprite.modulate = Color(1, 1, 1, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", 
	Color(1, 1, 1, 1), dur)

	await get_tree().create_timer(waittime).timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", 
	Color(1, 1, 1, 0), dur)
	
