extends Control

signal close_help

func _on_back_btn_pressed():
	emit_signal("close_help")
