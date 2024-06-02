extends Node2D

@export var dur = 1
@export var waittime = 3

@onready var sprite : Sprite2D = $Sprite2D
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	var size = get_viewport().size
	sprite.position.x = size.x / 2
	sprite.position.y = size.y / 2
	
	print('ready')
	sprite.modulate = Color(1, 1, 1, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", 
	Color(1, 1, 1, 1), dur)
	
	audio.play()

	await get_tree().create_timer(waittime).timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", 
	Color(1, 1, 1, 0), dur)
	
	await get_tree().create_timer(waittime).timeout
	
	get_tree().change_scene_to_file("res://playtesting.tscn")
	
