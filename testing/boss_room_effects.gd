extends Node2D

@onready var fire1 = $Fire1
@onready var fire2 = $Fire2
@onready var fire3 = $Fire3
@onready var fire4 = $Fire4
@onready var falling_particles = $Fall
@onready var world_env = $WorldEnvironment

# Called when the node enters the scene tree for the first time.
func _ready():
	fire1.emitting = false
	fire2.emitting = false
	fire3.emitting = false
	fire4.emitting = false
	falling_particles.emitting = false
	world_env.environment.glow_enabled = false

func _on_test_slime_boss_started():
	fire1.emitting = true
	fire2.emitting = true
	falling_particles.emitting = true
	falling_particles.process_material.initial_velocity_min = 150
	falling_particles.process_material.initial_velocity_max = 200
	falling_particles.position.y -= 100
	falling_particles.lifetime = 3

func _on_phase_two_start():
	fire3.emitting = true
	fire4.emitting = true
	falling_particles.process_material.initial_velocity_min = 300
	falling_particles.process_material.initial_velocity_max = 400
	world_env.environment.glow_enabled = true

func _on_test_slime_music_started():
	falling_particles.process_material.initial_velocity_min = 50
	falling_particles.process_material.initial_velocity_max = 50
	falling_particles.lifetime = 10
	falling_particles.position.y += 100
	falling_particles.emitting = true

var shake_strength = 0.0
var shake_fade = 5.0

@export var max_shake_strength : float = 5.0

func _on_test_slime_landed():
	shake_strength = max_shake_strength

@export var cam : Camera2D

var rng = RandomNumberGenerator.new()

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		cam.offset = random_offset()

func random_offset():
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
