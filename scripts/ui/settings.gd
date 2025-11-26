extends Control

@onready var volume_slider = $MarginContainer/MainSettingsPanel/MarginContainer/VBoxContainer/VolumeSection/VBoxContainer/Volume
@onready var how_to_play = $HowToPlay
@onready var main_panel = $MarginContainer

@onready var game_manager: GameManager = %GameManager

var is_paused: bool = false

func _ready():
	main_panel.visible = false
	how_to_play.visible = false
	volume_slider.value = GameState.volume

func _unhandled_input(event: InputEvent) -> void:
	if game_manager.is_game_over:
		return
	if event.is_action_pressed("ui_cancel"):
		if how_to_play.visible == true:
			_on_how_to_play_close_help()
		else:
			_toggle_pause()

func _toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	main_panel.visible = is_paused
	
func _on_volume_value_changed(value):
	var bus_idx = AudioServer.get_bus_index("Master")
	GameState.volume = value;
	
	if value == 0:
		AudioServer.set_bus_mute(bus_idx, true)
		return
		
	AudioServer.set_bus_mute(bus_idx, false)
	
	var db = linear_to_db(clamp(value, 0.001, 1.0))
	AudioServer.set_bus_volume_db(bus_idx,db)

func _on_resume_btn_pressed():
	_toggle_pause()

func _on_help_btn_pressed():
	main_panel.visible = false
	how_to_play.visible = true

func _on_how_to_play_close_help():
	main_panel.visible = true
	how_to_play.visible = false

func _on_new_game_btn_pressed():
	game_manager.start_new_game()

func _on_exit_game_btn_pressed():
	get_tree().paused = false
	get_tree().quit()
