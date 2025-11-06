extends Control

signal dialogue_finished

@onready var panel : Panel = $Panel
@onready var main_text : Label = $Panel/MarginContainer/VBoxContainer/MainText
@onready var prompt : Label = $Panel/SPACE

const CHARS_PER_SEC: float = 20.0
const FADE_IN_TIME: float = 0.25
const FADE_OUT_TIME: float = 0.25

var _messages: Array[String] = []

var _index = 0
var _visible = false
var _typing = false
var _elapsed = 0.0

func _ready():
	panel.modulate.a = 0.0
	main_text.visible_ratio = 0.0
	prompt.visible = false

func start(messages: Array[String]) -> void:
	if messages.is_empty():
		return
	
	_messages = messages
	_index = 0
	fade_in_panel()
	show_message()

func fade_in_panel():
	var tween = create_tween()

	tween.tween_property(panel, "modulate:a", 1.0, FADE_IN_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
	
	await tween.finished
	_visible = true

func fade_out_panel():
	_visible = false
	main_text.visible_ratio = 0.0
	prompt.visible = false

	var tween = create_tween()

	tween.tween_property(panel, "modulate:a", 0.0, FADE_OUT_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
	
	await tween.finished
	emit_signal("dialogue_finished")

func show_message():
	var message = _messages[_index]
	main_text.text = message
	main_text.visible_characters = 0
	_elapsed = 0.0
	_typing = true
	prompt.visible = false

func _process(delta):
	# If we aren't showing the panel, don't do anything
	if not _visible:
		return
	
	# Make sure we are supposed to be typing
	if _typing:
		# Figure out how many characters we should have typed by now
		_elapsed += delta
		var total_chars = main_text.get_total_character_count()
		var target_chars = int(_elapsed * CHARS_PER_SEC)
		main_text.visible_characters = clamp(target_chars, 0, total_chars)
		
		# Once we've typed all of them, typing is done
		if target_chars >= total_chars:
			_typing = false
			prompt.visible = true

func _unhandled_input(event):
	# If we aren't visible ignore any input
	if not _visible:
		return
	
	# if they didn't press space/enter, ignore
	if not event.is_action_pressed("ui_accept"):
		return
	
	# If we were mid way through typing, let's finish the message quickly
	if _typing:
		_typing = false
		main_text.visible_characters = -1
		prompt.visible = true
	# Otherwise the user is finished reading, so move on to next text line
	else:
		_index += 1
		if _index >= _messages.size():
			fade_out_panel()
		else:
			show_message()
	
	get_viewport().set_input_as_handled()
