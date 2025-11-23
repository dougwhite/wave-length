extends StaticBody2D

signal panel_died

@onready var explode_noise = $explode_noise
@onready var animation_player = $AnimationPlayer

func _on_health_died():
	emit_signal("panel_died")
	animation_player.play("explode")

func _on_health_ouch(_amount, _other):
	explode_noise.play()
