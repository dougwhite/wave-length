class_name Health
extends Node

@export var max_health: int = 100
var current_health: int

signal health_changed(_current: int, _max: int)
signal died

func _ready():
	current_health = max_health
	emit_signal("health_changed", current_health, max_health)

func take_damage(amount: int):
	if amount <= 0:
		return
	
	current_health = max(current_health - amount, 0)
	emit_signal("health_changed", current_health, max_health)
	
	if current_health == 0:
		emit_signal("died")
