extends Node2D

@onready var health = $Health
@onready var game_manager = %GameManager

@onready var solar_panel_1 = $SolarPanel1
@onready var solar_panel_2 = $SolarPanel2
@onready var solar_panel_3 = $SolarPanel3
@onready var solar_panel_4 = $SolarPanel4
@onready var solar_panel_5 = $SolarPanel5
@onready var solar_panel_6 = $SolarPanel6
@onready var solar_panel_7 = $SolarPanel7

func _on_health_died():
	# Climactically explode
	#explosion_sound.play()
	# Wait a moment
	await get_tree().create_timer(1.5).timeout
	# Terminate the game
	game_manager.game_over()

func _on_solar_panel_panel_died():
	health.take_damage(20, null)
