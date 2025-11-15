extends Control

@onready var hp_foreground = $Panel/hp_foreground
@onready var panel = $Panel
@onready var label = $Panel/Label

var health: Health
var _bar_max: float
var showing: bool = false
var stylebox: StyleBox

const FADE_IN_TIME = .75
const FADE_COL_TIME = .5
const FADE_OUT_TIME = 1.5
const PROG_COLOR = Color("#6ef0ff")
const DONE_COLOR = Color("#ff3fa4")

func _ready():
	# Figure out our maximum bar size
	_bar_max = hp_foreground.size.x
	stylebox = panel.get_theme_stylebox("panel")
	panel.modulate.a = 0.0	

func set_health_target(_health: Health):
	# Set the current health target
	health = _health
	
	# Set the current health
	_set_bar_health(health.current_health, health.max_health)
	
	# connect up health changed event
	health.health_changed.connect(_on_health_changed)

func _set_bar_health(_current: int, _max: int):
	hp_foreground.size.x = (float(_current) / float(_max)) * _bar_max

func _on_health_changed(_current: int, _max: int):
	_set_bar_health(_current, _max)

func fade_in():
	label.modulate = PROG_COLOR
	hp_foreground.modulate = PROG_COLOR
	stylebox.border_color = PROG_COLOR
	
	showing = true
	var tween = create_tween()

	tween.tween_property(panel, "modulate:a", 1.0, FADE_IN_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
	
	await tween.finished

func fade_out():
	showing = false
	var tween = create_tween()

	tween.parallel().tween_property(label, "modulate", DONE_COLOR, FADE_COL_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
	
	tween.parallel().tween_property(hp_foreground, "modulate", DONE_COLOR, FADE_COL_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
	
	tween.parallel().tween_property(stylebox, "border_color", DONE_COLOR, FADE_COL_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)

	tween.parallel().tween_property(panel, "modulate:a", 0.0, FADE_OUT_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
	
	await tween.finished
