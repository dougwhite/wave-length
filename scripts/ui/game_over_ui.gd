extends Control

signal new_game
signal retry

func _on_new_game_btn_pressed():
	emit_signal("new_game")
