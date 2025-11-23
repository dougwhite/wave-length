extends StaticBody2D

signal panel_died

@onready var explode_noise = $explode_noise

func _on_health_died():
	emit_signal("panel_died")
	queue_free()

func _on_health_ouch(_amount, _other):
	explode_noise.play()
