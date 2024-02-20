extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
@onready var health_bar:ProgressBar = $health_ProgressBar

func update_health_bar():
	health_bar.value = Globals.player_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
