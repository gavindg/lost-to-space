extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
var player_hit: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_slime_weapon_area_2d_body_entered(_body):
	player_hit = true
	var targets = get_tree().get_nodes_in_group("Player")
	for target in targets:
		target.take_damage()


func _on_slime_weapon_area_2d_body_exited(_body):
	player_hit = false
