class_name SpaceFiend
extends Node2D

#var playerPos : CharacterBody2D = null
@onready var body : CharacterBody2D = $Body
@export var speed : float = 100
@export var target : Vector2 = Vector2.ZERO



func _process(_delta: float) -> void:
	var direction = (target - position).normalized()
	if direction.is_equal_approx(Vector2.ZERO):
		direction = 0
	body.set_velocity(speed * direction)
	body.move_and_slide();
