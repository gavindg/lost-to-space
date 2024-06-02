extends ParallaxBackground


func _ready():
	var resolution = get_viewport().size
	scale = Vector2(resolution)/Vector2(1152,648)
	
