extends Control

signal open_dialogue

@onready var name_label = $NinePatchRect/Label
@onready var content_label = $NinePatchRect/RichTextLabel

var current_index = 0
var is_active = false

@export var dialogue = [
	{"text": "hello", "duration": 2.0},
	{"text": "how are you", "duration": 5},
]

var timer = Timer.new()

func _ready():	
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)
	connect("open_dialogue", _on_open_dialogue)
	_on_open_dialogue()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		open_dialogue.emit()
	
func _on_open_dialogue():
	if current_index < len(dialogue):
		visible = true
		content_label.text = dialogue[current_index].text
		
		# Set up timer
		timer.wait_time = dialogue[current_index].duration
		timer.one_shot = true
		
		current_index += 1
		
		timer.start()

func _on_timer_timeout():
	visible = not visible
	queue_free()
