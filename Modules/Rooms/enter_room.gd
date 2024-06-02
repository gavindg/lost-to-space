extends Area2D

var entered = false

func _process(delta):
	if entered == true:
		if Input.is_action_just_pressed("interact"):
			get_tree().change_scene_to_file("res://testing/PlaytestBossCave.tscn")

func _on_body_entered(body):
	print("entered", body)
	if body.name == "Michael":
		entered = true

func _on_body_exited(body):
	print("exited", body)
	if body.name == "Michael":
		entered = false
