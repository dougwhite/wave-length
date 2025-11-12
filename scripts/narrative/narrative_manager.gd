extends Node

@onready var player = $"../Objects/Player"
@onready var camera_2d = $"../Objects/Player/Camera2D"
@onready var title = $"../Title"
@onready var dialog_box = $"../CanvasLayer/DialogBox"
@onready var objectives = $"../CanvasLayer/Objectives"
@onready var arrow = $"../Objects/Player/Arrow"
@onready var locations = $Locations
@onready var radio = $"../Objects/Radio"
@onready var radio_tower = $"../Objects/RadioTower"
@onready var seagull = $"../Objects/Seagull"

# Enum stages of the game
enum Stage {
	OPENING_TITLE,
	WAKE_ON_BEACH,
	WALK_TO_TOWER,
	RECEIVE_MESSAGE,
	USE_RADIO,
	BOOST_TOWER,
	SEAGULLS,
}
@export var start_stage = Stage.OPENING_TITLE
var current_stage: int

# Narrative actors
var Harry = DialogueSpeaker.new("Harry", Color("#6ef0ff"))
var Voice = DialogueSpeaker.new("", Color("#ff3fa4"))
var Radio = DialogueSpeaker.new("Radio", Color("#FFA36C"))

# Set up and start the story
func _ready() -> void:
	if OS.is_debug_build():
		current_stage = start_stage
	else:
		current_stage = Stage.OPENING_TITLE
	
	# Ensure the player starts at the start zone
	player.global_position = zone("PlayerStart").global_position

	feature_gate()
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
		Stage.USE_RADIO:
			await _stage_use_radio()
		Stage.BOOST_TOWER:
			await _stage_boost_tower()
		Stage.SEAGULLS:
			await _stage_seaguls()

# Ensures unlocked features are available when jumping to a later scene
func feature_gate() -> void:
	if current_stage > Stage.BOOST_TOWER:
		player.feature_tuning = true
		player.feature_firing = true


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
	# Halt the player input while we move the camera
	player.input_enabled = false
	
	# Pan the camera to the target
	var tween = create_tween()
	tween.tween_property(camera_2d, "global_position", target.global_position, duration) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_OUT)
	await tween.finished
	
	# Re-enable player input when we are done
	player.input_enabled = true

# Fade in the title menu, wait for them to press space
func _stage_opening_title():
	# Disable the player input when we are at the title
	player.input_enabled = false
	
	# Harry starts by sleeping
	player.animated_sprite.play("sleep")
	
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
	
	# Turn on the radio light
	radio.light_on = true
	
	# Focus camera on the radio hut
	await zoom(zone("RadioHutZoom"))
	
	# Harry is confused
	await dialog([
		Harry.say("A message!?"),
		Harry.say("Must be a mistake...")
	])

	# Focus camera back on harry
	await zoom(player)
	
	# Start the next stage
	current_stage = Stage.USE_RADIO
	start_story()

func _stage_use_radio():
	# If we are in debug, start next to the radio tower
	teleport(zone("RadioHutZone"))
	
	# Turn on the radio light in case we started here in debug mode
	radio.light_on = true
	
	# Teach the player how to interact with things
	objectives.show_objective("Move closer to the radio and press 'E' to interact with it")
	arrow.objective = radio
	
	# Wait for players to find their way to the tower
	await radio.interacted
	
	# complete the objective
	objectives.complete_objective()
	arrow.objective = null
	
	# disable the radio
	radio.disabled = true
	
	# The radio transmission
	await dialog([
		Radio.say("*kssshhh* ...MAYDAY! MAYDAY, COASTAL STATION... *krrt*"),
		Radio.say("*kssssht* ...multiple entities... *kssssht*"),
		Radio.say("*krrt* ...closing fast on your island... *ksssh*"),
		Radio.say("*kssshh* ...any minute... *krrt*"),
		Radio.say("*ksssh* ...you must prepa-...*signal lost*"),
	])
	
	# Turn the radio light off
	radio.light_on = false
	
	# Harry is in denial, but "good" at his job
	await dialog([
		Harry.say("..."),
		Harry.say("Definitely a mistake."),
		Harry.say("Still... Protocol says I should boost the signal if a Mayday is in range."),
		Harry.say("What was that damn frequency again?")
	])
	
	# Start the next stage
	current_stage = Stage.BOOST_TOWER
	start_story()

func _stage_boost_tower():
	# If we are in debug, start next to the radio tower
	teleport(zone("RadioHutZone"))

	# Enable tuning
	player.feature_tuning = true
	
	# Teach the player how to tune his radio
	objectives.show_objective("\n\n".join([
		"Find the frequency of the radio tower",
		"Hold Q to enter tuning mode",
		"Move your mouse left and right until you see the radio tower glowing",
	]))
	arrow.objective = radio_tower
	
	# Wait for the player to find the right frequency
	await radio_tower.frequency_tuned
	
	# Look you did it Harry!
	objectives.complete_objective()
	
	# Hint to the player where they need to aim
	await zoom(radio_tower)
	await dialog([
		Harry.say("Got it. Now I just need to aim at the tower and emit a quick signal pulse..."),
	])
	
	# Ok zoom back on the player
	await zoom(player)
	
	# Give them the next objective
	objectives.show_objective("\n\n".join([
		"Left Click to activate your frequency emitter",
		"Remember to aim at the tower"
	]))
	
	# Enable firing ma lazor
	player.feature_firing = true

	# Wait for the player to shoot the tower
	await radio_tower.tower_hit
	
	# Yay they learned to shoot, complete the objective for them
	objectives.complete_objective()
	arrow.objective = null
	
	# Harry is confused, why didn't it work?
	await dialog([
		Harry.say("Nailed it!"),
		Harry.say("Wait... why didn't that work?"),
	])
	
	# Start the next stage
	current_stage = Stage.SEAGULLS
	start_story()
	
func _stage_seaguls():
	# If we are in debug, start next to the radio tower
	teleport(zone("RadioHutZone"))
	
	# Harry must find out what's blocking the signal
	objectives.show_objective("\n\n".join([
		"Figure out the source of the signal disturbance"
	]))
	
	# Now wait for the player to figure out how to blast the seagull
	await seagull.seagull_flee
	
	# They did it!
	objectives.complete_objective();
	
	# Now some flavor dialog
	await dialog([
		Harry.say("Shoo!"),
	])
	
	# Now they've proven they can tune in to things, 
	objectives.show_objective("\n\n".join([
		"Finish boosting the signal by shooting a radio wave at the tower",
		"[Completes tutorial!]"
	]))
	arrow.objective = radio_tower
	
