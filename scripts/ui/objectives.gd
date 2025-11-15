extends Control

@onready var panel = $VBoxContainer/PanelContainer
@onready var label = $VBoxContainer/PanelContainer/MarginContainer/Label
@onready var health_bar = $VBoxContainer/HealthBar

const FADE_IN_TIME = .75
const FADE_COL_TIME = .5
const FADE_OUT_TIME = 1.5
const PROG_COLOR = Color("#6ef0ff")
const DONE_COLOR = Color("#ff3fa4")

var stylebox: StyleBox

# Called when the node enters the scene tree for the first time.
func _ready():
	stylebox = panel.get_theme_stylebox("panel")
	panel.modulate.a = 0.0

func show_objective(objective: String):
	label.text = objective
	label.modulate = PROG_COLOR
	stylebox.border_color = PROG_COLOR
	_fade_in()

func show_health_bar(target: Health):
	health_bar.set_health_target(target)
	health_bar.fade_in()

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
	
	# If the health bar is showing, we should hide that too
	if health_bar.showing:
		health_bar.fade_out()
		
	await tween.finished
