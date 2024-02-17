extends Area2D
var damage = 10

func _ready():
	pass

func _on_Weapon_area_entered(area):
	if area is CharacterBody2D:
		area.apply_damage(damage)
