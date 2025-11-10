extends CharacterBody2D

var input_enabled = true

@onready var animated_sprite = $AnimatedSprite2D
@onready var selection_radius = $SelectionRadius
@onready var game_manager: GameManager = %GameManager

@export var tuner: RadioTuner

var feature_tuning = false
var feature_firing = false

const SPEED = 300.0
const WAVE_SPAWN_DIST = 50.0

var last_dir = 1 	# 0 - right, 1 - left, 2 - down, 3 - up
var tune_mode = false
var fine_tuning = false

func _physics_process(_delta):
	
	if not input_enabled:
		if not animated_sprite.animation == "sleep":
			idle_sprite()
		return;

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	direction = Input.get_axis("move_up", "move_down")
	if direction:
		velocity.y = direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if velocity.length() > 0:
		if velocity.x > 0:
			animated_sprite.play("walk_right")
			last_dir = 0
		elif velocity.x < 0:
			animated_sprite.play("walk_left")
			last_dir = 1
		elif velocity.y > 0:
			animated_sprite.play("walk_down")
			last_dir = 2
		elif velocity.y < 0:
			animated_sprite.play("walk_up")
			last_dir = 3
		
	else:
		idle_sprite()
			
	move_and_slide()

func idle_sprite():
	if last_dir == 0:
		animated_sprite.play("idle_right")
	elif last_dir == 1:
		animated_sprite.play("idle_left")
	elif last_dir == 2:
		animated_sprite.play("idle_down")
	elif last_dir == 3:
		animated_sprite.play("idle_up")

func _input(event):
	if not input_enabled:
		# If input was disabled and we were still in tune mode, we better fix that
		if tune_mode:
			exit_tune_mode()
			fine_tuning = false
		return

	# If the player presses interact, send an interact event to any selectables in the area
	if event.is_action_pressed("interact"):
		for body in selection_radius.get_overlapping_bodies():
			if body.is_in_group("selectables"):
				body.interact()
	
	# Handle input for radio tuning
	_input_tuning(event)
	
	# Handle input for firing radio emitter
	_input_firing(event)

func _input_tuning(event):
	# Player must unlock tuning feature via story progression first
	if not feature_tuning:
		return
	
	# If the player presses Q we start tuning mode
	if event.is_action_pressed("tune_mode"):
		enter_tune_mode()
	
	# If the player releases Q stop tuning
	elif event.is_action_released("tune_mode"):
		exit_tune_mode()

	# While tuning mode is on, mouse movement changes the station
	elif tune_mode and event is InputEventMouseMotion:
		tuner.move_needle(event.relative.x)	
	
	# Scrolling the mouse wheel change the station (only when not in tune mode)
	elif not tune_mode and event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				tuner.move_band(-1 if fine_tuning else -3)
				fade_tuner_in()
				fade_tuner_out()
			MOUSE_BUTTON_WHEEL_DOWN:
				tuner.move_band(1 if fine_tuning else 3)
				fade_tuner_in()
				fade_tuner_out()

	# Holding shift enables fine tuning for mouse wheel
	elif event.is_action_pressed("fine_tune"):
		fine_tuning = true
	elif event.is_action_released("fine_tune"):
		fine_tuning = false

	# +/- tune up and down too
	elif event.is_action_pressed("tune_up"):
		tuner.move_band(1)
		fade_tuner_in()
		fade_tuner_out()
	elif event.is_action_pressed("tune_down"):
		tuner.move_band(-1)
		fade_tuner_in()
		fade_tuner_out()
	
	# Numbers 1-7 select an exact color band
	elif event.is_action_pressed("tune_1"):
		tuner.set_band(0)
		fade_tuner_in()
		fade_tuner_out()
	elif event.is_action_pressed("tune_2"):
		tuner.set_band(6)
		fade_tuner_in()
		fade_tuner_out()
	elif event.is_action_pressed("tune_3"):
		tuner.set_band(12)
		fade_tuner_in()
		fade_tuner_out()
	elif event.is_action_pressed("tune_4"):
		tuner.set_band(18)
		fade_tuner_in()
		fade_tuner_out()
	elif event.is_action_pressed("tune_5"):
		tuner.set_band(24)
		fade_tuner_in()
		fade_tuner_out()
	elif event.is_action_pressed("tune_6"):
		tuner.set_band(30)
		fade_tuner_in()
		fade_tuner_out()
	elif event.is_action_pressed("tune_7"):
		tuner.set_band(36)
		fade_tuner_in()
		fade_tuner_out()

func enter_tune_mode():
	tune_mode = true
	fade_tuner_in()

func exit_tune_mode():
	tune_mode = false
	fade_tuner_out()

func fade_tuner_in():
	tuner.fade_in()

func fade_tuner_out():
	if tune_mode:
		return
	tuner.hide_later()

func _input_firing(event):
	# Player must unlock shooting feature via story progression first
	if not feature_firing:
		return
	
	if event.is_action_pressed("fire"):
		fire_wave()

func fire_wave():
	# Figure out where the mouse is from the player
	var mouse_pos: Vector2 = get_global_mouse_position()
	var player_center = global_position + Vector2(0.0, -55.0)
	var dir: Vector2 = (mouse_pos -  player_center).normalized()
	var wave_spawn_point = player_center + (dir * WAVE_SPAWN_DIST)
	# spawn a wave projectile
	game_manager.spawn_wave(wave_spawn_point, dir)

func _on_selection_radius_body_entered(body):
	if body.is_in_group("selectables"):
		body.selected = true

func _on_selection_radius_body_exited(body):
	if body.is_in_group("selectables"):
		body.selected = false
