class_name RadioTuner
extends Control

@onready var needle = $needle
@onready var game_manager = %GameManager

const MIN_X = 60.0
const MAX_X = 380.0
const BANDS = 37
const FADE_IN_TIME = .25
const FADE_DELAY = 1.0
const FADE_OUT_TIME = .25

const X_RANGE = MAX_X - MIN_X
const X_PER_BAND = X_RANGE / BANDS

@export var needle_x: float = 0.0

var hide_self = false
var show_s = 0.0

func _ready():
	modulate.a = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hide_self:
		show_s -= delta
		if show_s <= 0:
			fade_out()

# Moves the needle by a float amount
func move_needle(_x: float):
	needle_x += _x
	_set_frequency()

# Sets a specific band
func set_band(_band: int):
	needle_x = _band_to_x(_band)
	_set_frequency()

# Moves the band
func move_band(_band: int):
	needle_x += _band * X_PER_BAND
	_set_frequency()

# Clamps the needle value, set's the x position of the needle sprite, 
# and notifies the game manager that the frequency has changed
func _set_frequency():
	needle_x = clamp(needle_x, 0, X_RANGE - 0.000001)
	needle.position.x = MIN_X + needle_x
	game_manager.current_frequency = _x_to_band(needle_x)

# converts a given radio band to an x location for the sprite
func _band_to_x(_band: int) -> float:
	return (_band * X_PER_BAND)

# converts an x location into the corresponding band
func _x_to_band(_needle_x: float) -> int:
	return floor(_needle_x / X_PER_BAND)

# Fades in the radio tuner, turns off self hiding
func fade_in():
	hide_self = false
	var tween = create_tween()

	tween.tween_property(self, "modulate:a", 1.0, FADE_IN_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)

# Fades out the radio tuner, turns off self hiding
func fade_out():
	hide_self = false
	var tween = create_tween()

	tween.tween_property(self, "modulate:a", 0.0, FADE_OUT_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)

# Queues a fade out effect for the future
func hide_later(seconds: float = FADE_DELAY):
	hide_self = true
	show_s = seconds
