class_name RadioTuner
extends Control

@onready var needle = $needle

const MIN_X = 60.0
const MAX_X = 380.0
const BANDS = 37
const FADE_IN_TIME = .25
const FADE_DELAY = 1.0
const FADE_OUT_TIME = .25

const X_RANGE = MAX_X - MIN_X
const X_PER_BAND = X_RANGE / BANDS

@export var needle_x: float = 0.0

var band: int = 0
var hide_self = false
var show_s = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	needle_x = clamp(needle_x, 0, X_RANGE - 0.000001)
	needle.position.x = MIN_X + needle_x
	band = _x_to_band(needle_x)
	
	if hide_self:
		show_s -= delta
		if show_s <= 0:
			fade_out()

# Moves the needle by a float amount
func move_needle(_x: float):
	needle_x += _x

# Sets a specific band
func set_band(_band: int):
	needle_x = _band_to_x(_band)

# Moves the band
func move_band(_band: int):
	needle_x += _band * X_PER_BAND

func _band_to_x(_band: int) -> float:
	return (_band * X_PER_BAND)

func _x_to_band(_needle_x: float) -> int:
	return floor(_needle_x / X_PER_BAND)

func fade_in():
	hide_self = false
	var tween = create_tween()

	tween.tween_property(self, "modulate:a", 1.0, FADE_IN_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)

func fade_out():
	hide_self = false
	var tween = create_tween()

	tween.tween_property(self, "modulate:a", 0.0, FADE_OUT_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)

func hide_later(seconds: float = FADE_DELAY):
	hide_self = true
	show_s = seconds
