class_name Health
extends Node

@export var max_health: int = 100
var invulnerable: bool = false
var current_health: int

signal health_changed(_current: int, _max: int)
signal ouch(amount: int, other: Node)
signal died

func _ready():
	current_health = max_health
	emit_signal("health_changed", current_health, max_health)

func take_damage(amount: int, other: Node):
	# If the amount was less than 0 for some reason, nothing happens
	if amount <= 0:
		return
	
	if invulnerable:
		return
	
	# Let subscibers know that we were damaged
	emit_signal("ouch", amount, other)
	
	# Let subscibers know that our health has changed
	current_health = max(current_health - amount, 0)
	emit_signal("health_changed", current_health, max_health)
	
	# If we went under 0, let subscribers know we died
	if current_health == 0:
		emit_signal("died")
