extends NinePatchRect

@onready var content_label = $RichTextLabel
	
var current_index = 0
var is_active = false

@export var dialogue = {
	"intro_flag": [
		"WARNING: R.E.S.S. Soul Soil has sustained severe damage and requires immediate emergency repair. Flight is ill advised.",
		"The R.E.S.S Soul Soil is unable to fly in its current state. It is recommended that you gather the necessary materials to make repairs from the surrounding environment.",
		"Recover samples from the planet and submit them to me for analysis."],
	"explain_planet_flag_1": [
		"Hello, I am Galactic Guide Artificial Intelligence, or GGAI for short. I am built into your suit and will be assisting you.",
		"This planet is Avalora."
	]
}

#func _ready():	
	#connect("open_dialogue", _on_open_dialogue)

var current_flag = ""

func _process(_delta):
	if Input.is_action_just_pressed("adv_dialogue") and is_active:
		current_index += 1
		_on_open_dialogue(current_flag)
		
func _on_open_dialogue(flag):
	if current_index >= len(dialogue[flag]):
		_on_close_dialogue()
		return
	visible = true
	is_active = true
	content_label.text = dialogue[flag][current_index]
	current_flag = flag
		
	#if current_index < len(dialogue):
		#visible = true
		#content_label.text = dialogue[current_index].text
		
		# Set up timer
		#timer.wait_time = dialogue[current_index].duration
		#timer.one_shot = true
		#
		#current_index += 1
		#
		#timer.start()
		
func _on_close_dialogue():
	visible = false
	is_active = false
	current_index = 0
