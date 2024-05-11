extends CanvasLayer


@onready var health_bar:ProgressBar = $health_ProgressBar
@onready var timer = $Timer

var time_passed = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()
	


func update_health_bar():
	health_bar.value = Globals.player_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_timer_timeout():
	time_passed += 1
	var hours = time_passed / 1.0 / 3600
	var minutes = (time_passed % 3600) / 1.0 / 60
	var seconds = time_passed % 60
	$time_Label.text = "%02d:%02d:%02d" % [hours, minutes, seconds]
