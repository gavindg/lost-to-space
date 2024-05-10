extends CanvasLayer


@onready var player_health_bar : ProgressBar = $health_ProgressBar

var time_passed = 0;

func update_health_bars():
	player_health_bar.value = Globals.player_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# TODO: chat, is this real
	update_health_bars()
	pass
