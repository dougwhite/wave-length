class_name Tunable
extends Node2D

@onready var glow: Sprite2D = $glow
@onready var game_manager: GameManager = %GameManager

@export var band: int = 0
@export var base_color: Color = Color.WHITE

var last_freq = -1

var resonance_level = 0

var max_a = 0.0
var min_a = 0.0
var pulse_a_per_sec = 0
var ascending = true

func _ready():
	glow.modulate = game_manager.frequency_color(band)
	add_to_group("tunables")

func _process(delta):
	# If the frequency has changed, we need to update
	if last_freq != game_manager.current_frequency:
		last_freq = game_manager.current_frequency
		resonate(last_freq)

	# Figure out the speed of the alpha change
	var pulse = pulse_a_per_sec * delta
	if not ascending:
		pulse *= -1
	
	# Pulse the alpha of the sprite
	glow.modulate.a = glow.modulate.a + pulse

	# Check if we need to change direction
	if ascending and glow.modulate.a >= max_a:
		ascending = false
	elif not ascending and glow.modulate.a <= min_a:
		ascending = true

# Figures out if we are responding to a frequency and how strongly
func resonate(freq: int):
	var resonance = abs(freq - band)
	
	if resonance >= 0 and resonance < 1:
		max_a = 1.0
		min_a = 0.5
		pulse_a_per_sec = 1.0
		resonance_level = 2
	elif resonance >= 1 and resonance <= 3:
		max_a = 0.6
		min_a = 0.3
		pulse_a_per_sec = 0.4
	elif resonance > 3 and resonance <= 6:
		max_a = 0.3
		min_a = 0.2
		pulse_a_per_sec = 0.1
	else:
		max_a = 0.0
		min_a = 0.0
		pulse_a_per_sec = 1.0
