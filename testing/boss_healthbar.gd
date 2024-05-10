extends ProgressBar

@export var boss : EnemyCombat

func show_bar():
	pass

func _ready() -> void:
	if not boss:
		return
	max_value = boss.stats.max_hp
	await get_tree().create_timer(1).timeout
	appear()


func _process(_delta: float) -> void:
	if not boss:
		return
	value = boss.stats.hp


func appear():
	visible = true
