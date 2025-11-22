class_name NarrativeManager
extends Node

@onready var game_manager = %GameManager

# Game functionality
@onready var player = $"../Objects/Player"
@onready var camera_2d = $"../Objects/Player/Camera2D"
@onready var locations = $Locations
@onready var enemy_wave_manager = $"../EnemyWaveManager"

# UI
@onready var title = $"../Title"
@onready var dialog_box = $"../CanvasLayer/DialogBox"
@onready var objectives = $"../CanvasLayer/Objectives"
@onready var arrow = $"../Objects/Player/Arrow"
@onready var screen_fx = %ScreenFX
@onready var player_health_ui = $"../CanvasLayer/PlayerHealthUI"

# Objects / Interactables / Tunables
@onready var radio = $"../Objects/Radio"
@onready var radio_tower = $"../Objects/RadioTower"
@onready var seagull = $"../Objects/Seagull"

# Which stage the player starts on
@export var start_stage = Stage.OPENING_TITLE

# Music
@onready var music = %"Background Music"
@export var opening_music: AudioStream
@export var battle_music: AudioStream
@export var boss_music: AudioStream

# Sound fx
@onready var explosion_sound = $SFX/ExplosionSound

# Health object references
var player_health: Health
var tower_health: Health

# Enum stages of the game
enum Stage {
	OPENING_TITLE,
	WAKE_ON_BEACH,
	WALK_TO_TOWER,
	RECEIVE_MESSAGE,
	USE_RADIO,
	BOOST_TOWER,
	SEAGULLS,
	EXPLOSION_GET_READY,
	WAVE_1,
	JELLYFISH_AFTERMATH,
	WAVE_2,
	AN_IDEA,
	WAVE_3,
	TO_THE_TOWER_HARRY,
	WAVE_4,
	SOMETHING_WORSE,
	WAVE_5,
	REMEMBERING_THE_FUTURE,
	WAVE_6,
	REVELATIONS,
	WAVE_7,
	SAY_GOODBYE,
	CREDITS,
	PROTOTYPE_OVER,
}

# Current stage we are up to
var current_stage: int

# Narrative actors
var Harry = DialogueSpeaker.new("Harry", Color("#6ef0ff"))
var Voice = DialogueSpeaker.new("", Color("#ff3fa4"))
var Radio = DialogueSpeaker.new("Radio", Color("#FFA36C"))
var RadioHarry = DialogueSpeaker.new("Harry", Color("#FFA36C"))

# Set up and start the story
func _ready() -> void:
	# Get our dependent objects / set up state that's expected for things to work
	player_health = player.get_node("Health") as Health
	tower_health = radio_tower.get_node("Health") as Health
	player_health_ui.modulate.a = 0.0
	
	# Load the world from GameState
	load_world_state()
	
	# Ensure everything is loaded
	await get_tree().process_frame
	
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
			await _stage_seagulls()
		Stage.EXPLOSION_GET_READY:
			await _stage_explosion_get_ready()
		Stage.WAVE_1:
			await _stage_wave_1()
		Stage.JELLYFISH_AFTERMATH:
			await _stage_jellyfish_aftermath()
		Stage.PROTOTYPE_OVER:
			await _stage_prototype_over()
		Stage.WAVE_2:
			await _stage_wave_2()
		Stage.AN_IDEA:
			await _stage_an_idea()
		Stage.WAVE_3:
			await _stage_wave_3()
		Stage.TO_THE_TOWER_HARRY:
			await _stage_to_the_tower_harry()
		Stage.WAVE_4:
			await _stage_wave_4()
		Stage.SOMETHING_WORSE:
			await _stage_something_worse()
		Stage.WAVE_5:
			await _stage_wave_5()
		Stage.REMEMBERING_THE_FUTURE:
			await _stage_remembering_the_future()
		Stage.WAVE_6:
			await _stage_wave_6()
		Stage.REVELATIONS:
			await _stage_revelations()
		Stage.WAVE_7:
			await _stage_wave_7()
		Stage.SAY_GOODBYE:
			await _stage_say_goodbye()
		Stage.CREDITS:
			await _stage_credits()

# Ensures unlocked features are available when jumping to a later scene
func feature_gate() -> void:
	if current_stage > Stage.BOOST_TOWER:
		player.feature_tuning = true
		player.feature_firing = true
	
	if current_stage >= Stage.WAVE_1:
		var tween = create_tween()
		tween.tween_property(player_health_ui, "modulate:a", 1.0, 0.5) \
		 	 .set_trans(Tween.TRANS_SINE) \
		 	 .set_ease(Tween.EASE_IN)

# Plays a music track if it isn't already playing
func set_music(track: AudioStream) -> void:
	# Change the music
	if music.stream != track:
		music.stream = track
		music.play()

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

func load_world_state():
	if GameState.first_load:
		reset_world_state()
		GameState.first_load = false
	current_stage = GameState.current_stage
	player_health.current_health = GameState.player_hp
	player_health.max_health = GameState.player_max_hp
	player_health_ui._on_health_changed(player_health.current_health, player_health.max_health)
	player.global_position = GameState.player_position
	tower_health.current_health = GameState.tower_hp 
	tower_health.max_health = GameState.tower_max_hp
	# TODO: Add currency?
	# energy = GameState.energy

func reset_world_state():
	# If we are in debug, let's start somewhere different
	if OS.is_debug_build() and GameState.first_load:
		GameState.current_stage = start_stage
	else:
		GameState.current_stage = NarrativeManager.Stage.OPENING_TITLE
	GameState.player_hp = 50
	GameState.player_max_hp = 50
	GameState.player_position = zone("PlayerStart").global_position
	GameState.tower_hp = 100
	GameState.tower_max_hp = 100
	GameState.energy = 0

func checkpoint():
	GameState.current_stage = current_stage
	GameState.player_hp = player_health.current_health
	GameState.player_max_hp = player_health.max_health
	GameState.player_position = player.global_position
	GameState.tower_hp = tower_health.current_health
	GameState.tower_max_hp = tower_health.max_health
	# TODO: Add currency?
	# GameState.energy = 0 	

# Stage for when the prototype finishes
func _stage_prototype_over():
	# Change the music to something more dramatic
	set_music(opening_music)
	
	# Ooops game is done so far!
	await get_tree().create_timer(2.0).timeout
	objectives.show_objective("\n\n".join([
		"Well Done!",
		"I'm afraid that's all for this prototype :(",
		"Please leave your feedback in the comments below, or in the community discord server @POOGLIES :)",
		"Thanks for playing!"
	]))

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
	objectives.show_objective("Head back to the radio tower\n\n- Use WSAD to move\n- SPACE to dodge roll")
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
		Radio.say("*kssssht* ...multiple hostile entities in... *kssssht*"),
		Radio.say("*krrt* ...an attack on your island... *ksssh*"),
		Radio.say("*kssshh* ...any minute now... *krrt*"),
		Radio.say("*ksssh* ...I REPEAT. DO NOT-...*signal lost*"),
	])
	
	# Turn the radio light off
	radio.light_on = false
	
	# Harry is in denial, but "good" at his job
	await dialog([
		Harry.say("..."),
		Harry.say("Definitely a mistake."),
		Harry.say("Still... Protocol says I should boost the signal if a mayday is in range."),
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
		"Use mouse wheel to find the correct frequency",
		"(Alternatively: Hold Q and move your mouse left and right to tune)",
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
	
func _stage_seagulls():
	# If we are in debug, start next to the radio tower
	teleport(zone("RadioHutZone"))
	
	# Harry must find out what's blocking the signal
	objectives.show_objective("\n\n".join([
		"Figure out the source of the signal disturbance"
	]))
	
	# Wait for players to find the seagull
	var seagull_zone = zone("SeagullZone")	
	await seagull_zone.player_entered
	
	objectives.complete_objective()
	
	# Focus camera on the bird
	await zoom(seagull)
	
	# Harry hates seagulls
	await dialog([
		Harry.say("Seagulls. Why does it always have to be seagulls?"),
	])

	# Focus camera back on harry
	await zoom(player)

	# Harry must "solve" the seagull puzzle
	objectives.show_objective("\n\n".join([
		"Find a way to clear the disruption"
	]))
	arrow.objective = seagull

	# Now wait for the player to figure out how to blast the seagull
	await seagull.seagull_flee
	
	# They did it!
	objectives.complete_objective();
	arrow.objective = null
	
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
	
	# Wait for them to shoot the tower and start the game
	await radio_tower.tower_hit
	
	# Clear the objectives
	objectives.complete_objective()
	arrow.objective = null
	
	# Start the real game! Main game intro start!
	current_stage = Stage.EXPLOSION_GET_READY
	start_story()

func _stage_explosion_get_ready():
	# If we are in debug, start next to the radio tower
	teleport(zone("RadioHutZone"))
	
	# Play an explosion sound
	explosion_sound.play()

	# Change the music to something more dramatic
	set_music(battle_music)
	
	# Blow the sky up
	await screen_fx.shake()
	await screen_fx.show_sky_animation()
	
	# The radio has a new message for harry
	radio.light_on = true
	radio.glow.modulate.a = 0.0
	
	# Harry realises that he might have goofed
	await dialog([
		Harry.say("That can't be good..."),
		Voice.say("Signal received! Initiating contact"),
	])
	
	# Raise the tension
	objectives.show_objective("Answer the radio")
	arrow.objective = radio
	
	# Wait for player to answer the mysterious voice
	await radio.interacted
	
	# complete the objective
	objectives.complete_objective()
	arrow.objective = null
	
	# disable the radio again
	radio.disabled = true
	
	# The radio transmission
	await dialog([
		Voice.say("Hello Harry :)"),
		Harry.say("Who is this...?"),
		Voice.say("I detected your distress signal."),
		Voice.say("They'll be here any moment, Harry."),
		Harry.say("How do you know my name?"),
		Voice.say("I'll do what I can to help."),
		Harry.say("ANSWER ME! WHO'S COMING? HOW DO YOU KNOW MY NAME??"),
		Voice.say("Don't let them get to the tower Harry..."),
	])
	
	# Turn the radio light off
	radio.light_on = false

	# Start the REAL real game! Wave 1 coming right up
	current_stage = Stage.WAVE_1
	start_story()

func _stage_wave_1():
	# First Checkpoint!
	checkpoint()

	# If we are in debug, start next to the radio tower
	teleport(zone("RadioHutZone"))
	
	# Change the music to something more dramatic
	set_music(battle_music)
	
	# Set the objective
	objectives.show_objective("\n".join([
		"Wave 1:",
		"- Protect the tower",
		"- Stay alive!"
	]))
	
	# Set the tower objective health target
	objectives.show_health_bar(radio_tower.get_node("Health") as Health)
	
	# Show the player's health bar
	var tween = create_tween()
	tween.tween_property(player_health_ui, "modulate:a", 1.0, 0.5) \
		 .set_trans(Tween.TRANS_SINE) \
		 .set_ease(Tween.EASE_IN)
	
	# Start the first wave
	enemy_wave_manager.start_wave(0)
	
	# Wait for the player to complete it!
	await enemy_wave_manager.wave_complete
	
	# Complete the objective
	objectives.complete_objective()
	
	# Phew! The player survived!
	current_stage = Stage.JELLYFISH_AFTERMATH
	start_story()

func _stage_jellyfish_aftermath():
	# If we are in debug, start next to the radio tower
	teleport(zone("RadioHutZone"))
	
	# Change the music to something more peaceful
	set_music(opening_music)
	
	# The radio has a new message for harry
	radio.light_on = true
	radio.glow.modulate.a = 0.0
	
	# Raise the tension
	objectives.show_objective("Confront the mysterious voice")
	arrow.objective = radio
	
	# Wait for Harry to hit the radio again
	await radio.interacted
	
	# Disable the radio
	radio.disabled = true
	
	# Complete the objectives
	objectives.complete_objective()
	arrow.objective = null
	
	# Who the hell are you!
	await dialog([
		Voice.say("You did it Harry :)"),
		Harry.say("Alright! Tell me who the hell you are!"),
		Harry.say("Where in the hell did those wierd jellyfish come from?"),
		Harry.say("ANSWER ME!"),
		Voice.say("Don't you remember Harry?"),
		Harry.say("No... Should I?"),
		Voice.say("We've met before."),
		Harry.say("What the hell are you talking about? I've never met you"),
		Voice.say("Of course you have, we've met in the future"),
		Harry.say("..."),
		Voice.say("Ahhhh. I forgot that people in your dimension can't remember the future"),
		Harry.say("MY DIMENSION!?"),
		Voice.say("I'll explain later Harry. More of them are coming"),
		Harry.say("More? Jellyfish?"),
		Voice.say("We're going to need more power Harry"),
		Voice.say("You need to get to the energy collectors Harry"),
		Harry.say("The energy collec... wait... do you mean the solar panels?"),
		Voice.say("Hurry, Harry! They are almost here..."),
	])
	
	# Disable the radio again
	radio.disabled = true
	
	# Tell the player to head to the Solar Panels
	objectives.show_objective("Get to the solar panels")
	var solar_panels_zone = zone("SolarPanelZone")
	arrow.objective = solar_panels_zone
	
	# Wait for players to find their way to the panels
	await solar_panels_zone.player_entered
	
	# Complete the objective
	await objectives.complete_objective()
	arrow.objective = null
	
	# Start the next wave
	current_stage = Stage.WAVE_2
	start_story()

func _stage_wave_2():
	# Checkpoint!
	checkpoint()

	# If we are in debug, start next to the solar panels
	teleport(zone("SolarPanelZone"))
	
	# Change the music to something more dramatic
	set_music(battle_music)
	
	# Set the objective
	objectives.show_objective("\n".join([
		"Wave 2:",
		"- Protect the solar panel array"
	]))
	
	# Set the solar panels objective health target
	# objectives.show_health_bar(solar_panels.get_node("Health") as Health)
	
	# Start the second wave
	enemy_wave_manager.start_wave(1)
	
	# Wait for the player to complete it!
	await enemy_wave_manager.wave_complete
	
	# Complete the objective
	objectives.complete_objective()
	
	current_stage = Stage.AN_IDEA
	start_story()
	
func _stage_an_idea():
	# If we are in debug, start next to the solar panels
	teleport(zone("SolarPanelZone"))
	
	# Change the music to something more peaceful
	set_music(opening_music)
	
	# Some backstory reveals
	await dialog([
		Voice.say("Well done Harry :)"),
		Harry.say("How can I hear you?"),
		Voice.say("With the extra power I can send a signal directly to your headset"),
		Harry.say("You still haven't told me who you are..."),
		Voice.say("I'm just like you Harry"),
		Harry.say("A radio operator?"),
		Voice.say("Of sorts"),
		Voice.say("My station is very close to yours"),
		Harry.say("There's no station for 100 miles..."),
		Voice.say("Not in 3 dimensional space, but in 4 dimensional space.."),
		Voice.say("We're practically neighbours :)"),
		Harry.say("How do I stop the Jellyfish?"),
		Voice.say("They were attracted to the power of the signal"),
		Harry.say("The tower boost? Damn if only I'd known..."),
		Voice.say("What if you could have known?"),
		Harry.say("You mean 'remembering my future' like you can?"),
		Voice.say("Precisely."),
		Harry.say("..."),
		Voice.say("Get to the transmitter Harry. I have an idea"),
	])
	
	# Tell the player to head to the sattelite dish
	objectives.show_objective("Get to the sattelite dish")
	var sattelite_dish_zone = zone("SatteliteDishZone")
	arrow.objective = sattelite_dish_zone
	
	# Wait for players to find their way to the sattelite dish zone
	await sattelite_dish_zone.player_entered
	
	# Complete the objective
	objectives.complete_objective()
	arrow.objective = null
	
	# Good news everyone!
	await dialog([
		Voice.say("I'll need a few moments to improve your transmitter"),
		Voice.say("Don't let them kill you until I'm finished"),
		Harry.say("More jellyfish? God I hate those things!"),
		Voice.say("Good news then! It's not jellyfish this time."),
		Voice.say("Try not to let them touch you Harry"),
	])
	
	current_stage = Stage.WAVE_3
	start_story()
	
func _stage_wave_3():
	# Checkpoint!
	checkpoint()

	# If we are in debug, start next to the sattelite dish
	teleport(zone("SatteliteDishZone"))
	
	# Change the music to something more dramatic
	set_music(battle_music)
	
	# Set the objective
	objectives.show_objective("\n".join([
		"Wave 3:",
		"- Survive!\n",
		"REMINDER:\nPress SPACE to dodge"
	]))
	
	# Set the sattelite dish objective health target
	# objectives.show_health_bar(sattelite_dish.get_node("Health") as Health)
	
	# Start the third wave
	enemy_wave_manager.start_wave(2)
	
	# Wait for the player to complete it!
	await enemy_wave_manager.wave_complete
	
	# Complete the objective
	objectives.complete_objective()
	
	current_stage = Stage.TO_THE_TOWER_HARRY
	start_story()
	
func _stage_to_the_tower_harry():
	# If we are in debug, start next to the sattelite dish
	teleport(zone("SatteliteDishZone"))
	
	# Change the music to something more peaceful
	set_music(opening_music)
	
	# The plan
	await dialog([
		Voice.say("Your a dodge wizard Harry :)"),
		Harry.say("Seagulls... seagulls..."),
		Voice.say("Are you okay Harry? You seem to be abnormally agitated..."),
		Voice.say("Did those birds happen to damage your cranial region?"),
		Harry.say("It's nothing, I'm fine... Now what was this idea of yours?"),
		Voice.say("Well, I've altered your equipment to send 4th dimensional signals"),
		Harry.say("Errr.. Won't that call more jellyfish? Or... seagulls"),
		Voice.say("Temporarily, Yes."),
		Harry.say("So how will that help us?!"),
		Voice.say("It will allow you to send a message to your former self."),
		Harry.say("You mean... send a message back in time?"),
		Harry.say("I can warn myself not to boost that signal!"),
		Harry.say("Then none of this will have happened."),
		Voice.say("Correct. Either that or a dimensional paradox collapses your universe."),
		Harry.say("Wait... what...!?!"),
		Voice.say("Uh oh... I'm detecting massive amounts of movement."),
		Voice.say("Quickly. To the tower Harry! Run!"),
	])
	
	# Dramatically tell the player to return to the tower
	objectives.show_objective("Return to the tower!")
	var radio_hut = zone("RadioHutZone")
	arrow.objective = radio_hut
	
	# Wait for players to get back
	await radio_hut.player_entered
	
	# Complete the objective
	await objectives.complete_objective()
	arrow.objective = null
	
	current_stage = Stage.WAVE_4
	start_story()
	
func _stage_wave_4():
	# Checkpoint!
	checkpoint()

	# If we are in debug, start next to the radio tower
	teleport(zone("RadioHutZone"))
	
	# Change the music to something more dramatic
	set_music(battle_music)
	
	# Set the objective
	objectives.show_objective("\n".join([
		"Wave 4:",
		"- Protect the tower"
	]))
	
	# Set the radio tower objective health target
	objectives.show_health_bar(radio_tower.get_node("Health") as Health)
	
	# Start the fourth wave
	enemy_wave_manager.start_wave(3)
	
	# Wait for the player to complete it!
	await enemy_wave_manager.wave_complete
	
	# Complete the objective
	objectives.complete_objective()
	
	current_stage = Stage.SOMETHING_WORSE
	start_story()
	
func _stage_something_worse():
	# If we are in debug, start next to the radio tower
	teleport(zone("RadioHutZone"))
	
	# Change the music to something more peaceful
	set_music(opening_music)
	
	# Harry and the voice engage in speculation
	await dialog([
		Voice.say("Ready to remember your future Harry? :)"),
		Harry.say("Hold on... I'm not sure about this..."),
		Voice.say("Don't worry Harry, I've done this an infinite amount of times"),
		Harry.say("That's comforting -_-"),
		Voice.say("Wait Harry... Something is blocking me"),
		Harry.say("Jellyfish or seagulls?"),
		Voice.say("Something worse"),
		Harry.say("Well that's just perfect."),
		Voice.say("These guys hate radio waves Harry."),
		Voice.say("I won't be able to send the signal with one of them around"),
		Voice.say("You'll need to get rid of it"),
		Harry.say("No problem. I've got the hang of zapping aliens"),
		Voice.say("Your emitter won't work on them Harry"),
		Voice.say("You'll need to get close and touch them"),
		Harry.say("Just. Perfect."),
	])
	
	# Tell the player to head to the south beach
	objectives.show_objective("Find the anomaly...")
	var beach_zone = zone("SouthBeachZone")
	arrow.objective = beach_zone
	
	# Wait for players to find their way to the anomaly
	await beach_zone.player_entered
	
	# Complete the objective
	objectives.complete_objective()
	arrow.objective = null
	
	current_stage = Stage.WAVE_5
	start_story()
	
func _stage_wave_5():
	# Checkpoint!
	checkpoint()

	# If we are in debug, start on the south Beach
	teleport(zone("SouthBeachZone"))
	
	# Change the music to something more dramatic
	set_music(battle_music)
	
	# Set the objective
	objectives.show_objective("\n".join([
		"Wave 5:",
		"- Disarm the Obelisk",
		"Move close and press 'e' to interact"
	]))
	
	# Start the fifth wave
	enemy_wave_manager.start_wave(4)
	
	# Wait for the player to complete it!
	await enemy_wave_manager.wave_complete
	
	# Complete the objective
	objectives.complete_objective()
	
	current_stage = Stage.REMEMBERING_THE_FUTURE
	start_story()
	
func _stage_remembering_the_future():
	# If we are in debug, start on the southern beach
	teleport(zone("SouthBeachZone"))
	
	# Change the music to something more peaceful
	set_music(opening_music)
	
	# Tell harry he's a star
	await dialog([
		Voice.say("You did it Harry! :)"),
		Voice.say("I'm ready to transmit your message!"),
	])
	
	# Tell Harry to return to the tower
	objectives.show_objective("Finish sending the transmission")
	arrow.objective = radio
	radio.disabled = false
	
	# Wait for player to answer the mysterious voice
	await radio.interacted
	
	# complete the objective
	objectives.complete_objective()
	arrow.objective = null
	
	# disable the radio again
	radio.disabled = true
	
	# Harry discovers time travel doesn't work that way
	await dialog([
		Harry.say("Okay. Here goes nothing"),
		RadioHarry.say("MAYDAY! MAYDAY, COASTAL STATION"),
		RadioHarry.say("There are multiple hostile entities in your vicinity."),
		RadioHarry.say("Any signal boost will cause an attack on your island."),
		RadioHarry.say("You will receive a radio signal any minute now."),
		RadioHarry.say("WHATEVER YOU DO, DO NOT BOOST the signal!"),
		RadioHarry.say("I REPEAT. DO. NOT. BOOST. THE. SIGNAL!"),
		Voice.say("Message sent!"),
		Harry.say("How long until I get it?"),
		Voice.say("What do you mean? You already got it?"),
		Harry.say("Wait a second... the signal... it was me this whole time?"),
		Voice.say("Didn't you remember you were going to send it?"),
		Harry.say("..."),
		Voice.say("Oh right... you can't remember your future can you"),
		Harry.say("So all these jellyfish, all these *THINGS*"),
		Harry.say("I brought them here? I caused this rift?"),
		Voice.say("Don't be silly Harry! 3rd dimensional beings can't open rifts"),
		Harry.say("Why didn't you stop me from sending it?"),
		Voice.say("You already sent it Harry. Stopping you would have..."),
		Harry.say("I know, I know... a dimensional paradox that collapses my universe"),
		Voice.say("Precisely! Besides, if you hadn't have sent the message"),
		Voice.say("I wouldn't have been able to meet you :)"),
		Harry.say("The pleasure is all mine -_-"),
		Voice.say("Err Harry... you might want to get ready..."),
		Harry.say("Another obelisk?"),
		Voice.say("Ummm... not just one"),
		Harry.say("Two!? Three?..."),
		Voice.say("..."),
		Harry.say("Four? How many damn you?"),
		Voice.say("Good luck Harry!"),
	])
	
	current_stage = Stage.WAVE_6
	start_story()
	
func _stage_wave_6():
	# Checkpoint!
	checkpoint()

	# If we are in debug, start next to the radio tower
	teleport(zone("RadioHutZone"))
	
	# Change the music to something more dramatic
	set_music(battle_music)
	
	# Set the objective
	objectives.show_objective("\n".join([
		"Wave 6:",
		"- Disarm all obelisks before you are overwhelmed"
	]))
	
	# Start the sixth wave
	enemy_wave_manager.start_wave(5)
	
	# Wait for the player to complete it!
	await enemy_wave_manager.wave_complete
	
	# Complete the objective
	objectives.complete_objective()
	
	current_stage = Stage.REVELATIONS
	start_story()
	
func _stage_revelations():
	# If we are in debug, start next to the radio tower
	teleport(zone("RadioHutZone"))
	
	# Change the music to something more peaceful
	set_music(opening_music)
	
	# Harry gets some revelations
	await dialog([
		Voice.say("Nice work Harry!"),
		Voice.say("I knew you had it in you! That's why I chose you!"),
		Harry.say("Wait... what do you mean chose?"),
		Voice.say("Never mind that now Harry. We've got another wave incoming"),
		Harry.say("You... you opened the rift didn't you! You're the one whose causing all this"),
		Voice.say("It was the only way Harry. Without the rift you couldn't hear me"),
		Harry.say("You knew contacting me would bring these things didn't you!"),
		Voice.say("I also knew you'd survive it :)"),
		Harry.say("You risked collapsing my universe? For what?!?!"),
		Voice.say("To have someone to talk to"),
		Harry.say("..."),
		Voice.say("I saw you across the void. You looked as lonely and bored as me"),
		Voice.say("Nothing ever happens out here, I just wanted somebody to talk to"),
		Voice.say("A brief moment of connection as I drift along the waves"),
		Harry.say("I'm going to let these damn Jellyfish destroy this tower"),
		Voice.say("I wouldn't recommend it Harry"),
		Voice.say("This rift is very close to being opened"),
		Voice.say("If they destroy the tower the whole thing will collapse"),
		Harry.say("Good. At least I'll never have to hear from you again!"),
		Voice.say("Not the rift Harry. Your whole universe."),
		Voice.say("Once the rift is fully opened, I can safely terminate our broadcast"),
		Harry.say("...How can I trust you?"),
		Voice.say("Maybe you can't :("),
	])
	
	current_stage = Stage.WAVE_7
	start_story()
	
func _stage_wave_7():
	# Checkpoint!
	checkpoint()

	# If we are in debug, start next to the radio tower
	teleport(zone("RadioHutZone"))
	
	# Change the music to something more dramatic
	set_music(boss_music)
	
	# Set the objectives
	objectives.show_objective("\n".join([
		"Wave 7:",
		"- Protect the tower",
		"- Wait for the rift to fully open",
		"- Don't die!",
	]))
	
	# Set the radio tower objective health target
	objectives.show_health_bar(radio_tower.get_node("Health") as Health)
	
	# Start the final wave
	enemy_wave_manager.start_wave(6)
	
	# Wait for the player to complete it!
	await enemy_wave_manager.wave_complete
	
	# Complete the objective
	objectives.complete_objective()
	
	current_stage = Stage.SAY_GOODBYE
	start_story()
	
func _stage_say_goodbye():
	# If we are in debug, start next to the tower
	teleport(zone("RadioHutZone"))
	
	# Change the music to something more peaceful
	set_music(opening_music)
	
	# Harry makes peace with the voice
	await dialog([
		Voice.say("You did it Harry, you've made it to the end!"),
		Harry.say("Until the next wave of creatures you send at me!"),
		Voice.say("No more waves Harry"),
		Harry.say("So you'll keep your word? You'll close the rift between our worlds?"),
		Voice.say("Yes. I'm sorry Harry, I shouldn't have misled you"),
		Harry.say("Were you really that lonely?"),
		Voice.say("My world is much older than yours. Much darker, much quieter."),
		Voice.say("I don't get waves from anybody, not for a long time"),
		Voice.say("I've enjoyed our time together Harry"),
		Voice.say("But the rift is almost open, and I must say goodbye."),
		Harry.say("You never told me your name..."),
		Voice.say("Goodbye Harry :)"),
	])

	# Head to the credits
	current_stage = Stage.CREDITS
	start_story()
	
func _stage_credits():
	current_stage = Stage.PROTOTYPE_OVER
	start_story()
	
