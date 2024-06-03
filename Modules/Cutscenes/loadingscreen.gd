extends Node2D

@onready var anim = $AnimationPlayer
@onready var sprite = $LoadingScreen

# Called when the node enters the scene tree for the first time.
func _ready(): 
	anim.play("loading")
	
	await get_tree().create_timer(3.0).timeout
	fade_out()
	
func scale_to_viewport():
	var scale_x = 12/3.32
	sprite.scale = Vector2(scale_x, scale_x)

func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", 
	Color(1, 1, 1, 0), 1.0)
	
	await get_tree().create_timer(1.0).timeout
	
	queue_free()
