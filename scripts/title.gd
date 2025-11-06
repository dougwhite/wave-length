extends Control

signal start_game  # emit when the fade out finishes

@export var force_cinematic: bool = false

@onready var wave_label = $WAVE
@onready var slash_label = $slash
@onready var length_label = $LENGTH
@onready var prompt_label = $"prompt"

var _labels : Array[Label]
var _state = 0      # 0 = intro, 1 = idle, 2 = outro

const INITIAL_DELAY = 2
const DELAY_BETWEEN = 1  
const FADE_IN_TIME = 4
const FADE_OUT_TIME = .2
const TIME_PER_CHAR = .25

func _ready():
	# prep the labels array
	_labels = [wave_label, slash_label, length_label, prompt_label]
	
	if OS.is_debug_build() and not force_cinematic:
		fade_out_and_start()
		return
	
	# set all the labels to invisible
	for l in _labels:
		# The prompt label fades in, the other labels "type" in
		if l == prompt_label:
			l.modulate.a = 0.0
		else:
			l.visible_ratio = 0.0
	
	# start the fade in
	fade_in_sequence()

func fade_in_sequence() -> void:
	# make sure everything is ready
	await get_tree().process_frame
	
	# Initial pause to let the music drop
	await get_tree().create_timer(INITIAL_DELAY).timeout

	# Loop through each of the labels
	for l in _labels:
		# Figure out how long we need to take to fade in
		var fade_in = l.text.length() * TIME_PER_CHAR
		
		# Create an asyncronous tween on alpha and wait for it to finish
		var tween = create_tween()
		
		# The prompt label fades in, the other labels "type" in
		if l == prompt_label:
			tween.tween_property(l, "modulate:a", 1.0, FADE_IN_TIME) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_IN)
				# Switch state to idle
			_state = 1
		else:
			tween.tween_property(l, "visible_ratio", 1.0, fade_in)
		
		# Wait for the tween to finish before continuing	
		await tween.finished
		
		# Pause before next label
		await get_tree().create_timer(DELAY_BETWEEN).timeout

func _unhandled_input(event) -> void:
	# If we aren't awaiting a keypress (idle), then do nothing
	if _state != 1:
		return
	
	# If ui_accept (space/enter) is pressed, start the game
	if event.is_action_pressed("ui_accept"):
		_state = 2
		fade_out_and_start()
		# Let the viewport know we've handled this input
		get_viewport().set_input_as_handled()

func fade_out_and_start() -> void:
	# Create a single tween
	var tween = create_tween()
	
	# Use the same tween to fade out all labels
	for l in _labels:
		tween.tween_property(l, "modulate:a", 0.0, FADE_OUT_TIME) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_IN)
	
	# Async await for the tween to complete
	await tween.finished
	
	# Let the player know he's good to go
	emit_signal("start_game")
	
	# remove ourself from the scene
	queue_free()
