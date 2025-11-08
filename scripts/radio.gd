extends Interactable

@onready var light = $light
@export var light_on: bool = false : set = set_light_on
var _pulse_tween: Tween

# property setter for light_on
func set_light_on(value: bool) -> void:
	
	# first, handle the property setting itself
	if light_on == value:
		return
	light_on = value
	
	disabled = not light_on
	
	# dispose of any existing tween and recreate it
	if _pulse_tween:
		_pulse_tween.kill()
		_pulse_tween = null
	
	# If we have a message, kick off a pulsing light
	if light_on:
		_pulse_light()
	# otherwise just turn it off immediately
	else:
		light.modulate.a = 0.0

# Creates the light pulsing tween effect
func _pulse_light():
	# start at alpha 0
	light.modulate.a = 0.0
	
	# create the new tween, set it to infinitely loop
	_pulse_tween = create_tween()
	_pulse_tween.set_loops()
	
	# fade in
	_pulse_tween.tween_property(light, "modulate:a", 1.0, 0.5) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	
	# fade_out
	_pulse_tween.tween_property(light, "modulate:a", 0.0, 0.5) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
