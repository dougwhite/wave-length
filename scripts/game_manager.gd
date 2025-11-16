class_name GameManager
extends Node

@onready var narrative_manager = $"../NarrativeManager"
@onready var sfx = %SFX
@onready var game_over_ui = $"../CanvasLayer/GameOverUI"

@export var wave_projectile: PackedScene
@export var sfx_wave: AudioStream
@export var pitch_min: float = 0.95
@export var pitch_max: float = 1.05
@export var volume: float = -6.0

var current_frequency = 0

var COLORS := [
	Color("#780063"),	# 00
	Color("#b00071"),	# 01
	Color("#c90149"),	# 02
	Color("#f5175f"),	# 03
	Color("#e21837"),	# 04
	Color("#f2302a"),	# 05
	Color("#e71318"),	# 06
	Color("#f93a33"),	# 07
	Color("#f9290e"),	# 08
	Color("#fa4c11"),	# 09
	Color("#e5580e"),	# 10
	Color("#f08500"),	# 11
	Color("#de7508"),	# 12
	Color("#f2ae06"),	# 13
	Color("#d69a06"),	# 14
	Color("#dabd00"),	# 15
	Color("#9cb607"),	# 16
	Color("#bbce00"),	# 17
	Color("#00bf01"),	# 18
	Color("#03ea01"),	# 19
	Color("#02c500"),	# 20
	Color("#06ec05"),	# 21
	Color("#10b230"),	# 22
	Color("#04ba95"),	# 23
	Color("#09898b"),	# 24
	Color("#0098cc"),	# 25
	Color("#0372a1"),	# 26
	Color("#0377d9"),	# 27
	Color("#0b57c2"),	# 28
	Color("#0e5df0"),	# 29
	Color("#1336d0"),	# 30
	Color("#1a51ee"),	# 31
	Color("#191fce"),	# 32
	Color("#3d2ce1"),	# 33
	Color("#3313c8"),	# 34
	Color("#3a15de"),	# 35
	Color("#3217d1"),	# 36
]

func frequency_color(band: int) -> Color:
	return COLORS[wrapi(band, 0, COLORS.size())]

func spawn_wave(position: Vector2, direction: Vector2):
	var wave = wave_projectile.instantiate()
	wave.global_position = position
	wave.velocity = direction
	wave.band = current_frequency
	wave.color = frequency_color(current_frequency)
	get_tree().current_scene.add_child(wave)
	sfx.stream = sfx_wave
	sfx.volume_db = volume
	sfx.pitch_scale = randf_range(pitch_min, pitch_max)
	sfx.play()

func game_over():
	get_tree().paused = true
	game_over_ui.visible = true

func _on_game_over_ui_new_game():
	narrative_manager.reset_world_state()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_game_over_ui_retry():
	get_tree().paused = false
	get_tree().reload_current_scene()
