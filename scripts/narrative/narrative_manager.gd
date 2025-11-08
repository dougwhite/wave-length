extends Node

@onready var player = $"../Objects/Player"
@onready var camera_2d = $"../Objects/Player/Camera2D"
@onready var title = $"../Title"
@onready var dialog_box = $"../CanvasLayer/DialogBox"
@onready var objectives = $"../CanvasLayer/Objectives"
@onready var arrow = $"../Objects/Player/Arrow"
@onready var locations = $Locations

# Enum stages of the game
enum Stage {
	OPENING_TITLE,
	WAKE_ON_BEACH,
	WALK_TO_TOWER,
	RECEIVE_MESSAGE,
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
	
	# Ensure the player starts at the start zone
	player.global_position = zone("PlayerStart").global_position
	
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
		Stage.RECEIVE_MESSAGE:
			await _stage_receive_message()

func dialog(messages: Array[DialogueMessage]):
	# Whenever there is dialogue we need to freeze the player
	player.input_enabled = false
	
	# Kick off the dialog and await completion
	dialog_box.start(messages)
	await dialog_box.dialogue_finished
	
	# Re-enable player input
	player.input_enabled = true

func zone(_name: NodePath) -> Node2D:
	return locations.get_node_or_null(_name) as Node2D

# Helper to teleport the player when starting at non standard stages
func teleport(target: Node2D) -> void:
	if OS.is_debug_build() and current_stage == start_stage:
		player.global_position = target.global_position

# Helper for camera zooms
func zoom(target: Node2D, duration: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(camera_2d, "global_position", target.global_position, duration) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_OUT)
	await tween.finished

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
	camera_2d.position_smoothing_enabled = true
	
	# Focus camera on the player
	await zoom(player)
	
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
	
	# Harry is abashed
	await dialog([
		Harry.say("Oh man... What time is it?"),
		Harry.say("I'd better head back to the tower")
	])

	# Start the next stage
	current_stage = Stage.WALK_TO_TOWER
	start_story()

func _stage_walk_to_tower():
	
	# Give the player their first objective
	objectives.show_objective("Head back to the radio tower\nUse WSAD to move")
	var radio_hut = zone("RadioHutZone")
	arrow.objective = radio_hut
	
	# Wait for players to find their way to the tower
	await radio_hut.player_entered
	
	# Complete the objective
	objectives.complete_objective()
	arrow.objective = null
	
	# Start the next stage
	current_stage = Stage.RECEIVE_MESSAGE
	start_story()

func _stage_receive_message():
	
	# If we are in debug, start next to the radio tower
	teleport(zone("RadioHutZone"))
	
	# Focus camera on the radio hut
	await zoom(zone("RadioHutZoom"))
	
	# Harry is confused
	await dialog([
		Harry.say("A message!?"),
		Harry.say("Must be a mistake...")
	])

	# Focus camera back on harry
	await zoom(player)
