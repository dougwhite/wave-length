extends Control

@onready var panel = $PanelContainer
@onready var label = $PanelContainer/MarginContainer/Label

const FADE_IN_TIME = .75
const FADE_COL_TIME = .5
const FADE_OUT_TIME = 1.5
const PROG_COLOR = Color("#6ef0ff")
const DONE_COLOR = Color("#ff3fa4")

var stylebox: StyleBox

# Called when the node enters the scene tree for the first time.
func _ready():
	panel.modulate.a = 0.0

func show_objective(objective: String):
	stylebox = panel.get_theme_stylebox("panel")
	label.text = objective
	label.modulate = PROG_COLOR
	stylebox.border_color = PROG_COLOR
	_fade_in()
	
func complete_objective():
	await _fade_out()

func _fade_in():
	var tween = create_tween()

	tween.tween_property(panel, "modulate:a", 1.0, FADE_IN_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
	
	await tween.finished

func _fade_out():
	var tween = create_tween()

	tween.parallel().tween_property(label, "modulate", DONE_COLOR, FADE_COL_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
	
	tween.parallel().tween_property(stylebox, "border_color", DONE_COLOR, FADE_COL_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)

	tween.parallel().tween_property(panel, "modulate:a", 0.0, FADE_OUT_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
	
	await tween.finished
