extends Control

@onready var animation_player = $AnimationPlayer

func roll_credits():
	animation_player.play("roll_credits")
	await animation_player.animation_finished
