class_name Tunable
extends Node2D

@onready var glow: Sprite2D = $glow
@onready var game_manager: GameManager = %GameManager

@export var band: int = 0

@export var strong_hit_level = 0.9
@export var medium_hit_level = 0.6
@export var weak_hit_level = 0.3

const GLOW_RADIUS = 10.0
const GLOW_CURVE = 1.5

var last_freq = -1
var resonance = 0

func _ready():
	#glow.modulate = game_manager.frequency_color(band)
	glow.modulate.a = 0.0
	add_to_group("tunables")

func _process(delta):
	# If the frequency has changed, we need to update
	if last_freq != game_manager.current_frequency:
		last_freq = game_manager.current_frequency
		resonance = _calc_resonance(last_freq)
	
	# Apply the resonance glow
	var a = lerp(glow.modulate.a, resonance, 10.0 * delta)
	glow.modulate.a = a

func hit(freq: int, strength: float = 1.0) -> bool:
	var res = _calc_resonance(freq) * strength
	if res > strong_hit_level: 		# strong hit
		return strong_hit()
	elif res > medium_hit_level:  	# medium hit
		return medium_hit()
	elif res > weak_hit_level:  	# weak hit
		return weak_hit()
	else:
		print(name, " was hit but felt almost nothing")
		return false

# By default strong hits stop the wave
func strong_hit() -> bool:
	print(name, " was hit strongly!")
	any_hit()
	return true

# By default medium hits stop the wave
func medium_hit() -> bool:
	print(name, " was hit mediumly")
	any_hit()
	return true

# By default weak hits stop the wave
func weak_hit() -> bool:
	print(name, " was hit weakly")
	any_hit()
	return true

# Called whenever hit by strong, medium or weak
func any_hit() -> void:
	return

# Figures out if we are responding to a frequency and how strongly
func _calc_resonance(freq: int):
	# figure out how many bands away we are
	var d = abs(freq - band)
	
	# Normalize and invert (capped at GLOW_RADIUS)
	var t = 1.0 - float(d) / GLOW_RADIUS
	t = clamp(t, 0.0, 1.0)
	
	# Turn the linear into a resonance curve and return it
	return pow(t, GLOW_CURVE)
