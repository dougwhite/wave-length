extends Node

@onready var player = $"../Objects/Player"
@onready var camera_2d = $"../Objects/Player/Camera2D"
@onready var title = $"../Title"
@onready var dialog_box = $"../CanvasLayer/DialogBox"

# Enum stages of the game
enum Stage {
	OPENING_TITLE,
	WAKE_ON_BEACH,
	WALK_TO_TOWER
}
@export var start_stage = Stage.OPENING_TITLE
var current_stage: int

# Narrative actors
var Harry = DialogueSpeaker.new("Harry", Color.WHITE)
var Voice = DialogueSpeaker.new("", Color.CYAN)

# Set up and start the story
func _ready() -> void:
	if OS.is_debug_build():
		current_stage = start_stage
	else:
		current_stage = Stage.OPENING_TITLE
	
	start_story()

func start_story() -> void:
	await _run_current_stage()

func _run_current_stage() -> void:
	match current_stage:
		Stage.OPENING_TITLE:
			await _stage_opening_title()
		Stage.WAKE_ON_BEACH:
			await _stage_wake_on_beach()
		Stage.WALK_TO_TOWER:
			await _stage_walk_to_tower()

# Fade in the title menu, wait for them to press space
func _stage_opening_title():
	# Disable the player input when we are at the title
	player.input_enabled = false
	
	# The camera starts focused on the title
	camera_2d.position_smoothing_enabled = false
	camera_2d.position = title.camera_start
	
	# Fade in the title sequence
	title.fade_in_sequence()
	await title.start_game
	
	# Turn back on position smoothing 
	camera_2d.position_smoothing_enabled = false
	
	# Create a tween for the camera position to center it on the player
	var tween = create_tween()
	tween.tween_property(camera_2d, "position", Vector2(0, -64.0), 1.0) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_OUT)
	await tween.finished
	
	# Re-enable player input once the game starts
	player.input_enabled = true
	
	# Start the next stage
	current_stage = Stage.WAKE_ON_BEACH
	start_story()

func _stage_wake_on_beach():
	
	# The voice speaks
	await dialog([Voice.say("...Wake up Harry")])
	
	# Harry stands up
	player.animated_sprite.play("idle_down")
	
	# Harry speaks
	await dialog([
		Harry.say("Oh man... What time is it?"),
		Harry.say("I'd better head back to the tower")
	])

	# Start the next stage
	current_stage = Stage.WALK_TO_TOWER
	start_story()

func _stage_walk_to_tower():
	return

func dialog(messages: Array[DialogueMessage]):
	# Whenever there is dialogue we need to freeze the player
	player.input_enabled = false
	
	# Kick off the dialog and await completion
	dialog_box.start(messages)
	await dialog_box.dialogue_finished
	
	# Re-enable player input
	player.input_enabled = true
