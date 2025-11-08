# All interactables require a collisionshape2d
class_name Interactable
extends StaticBody2D

signal interacted

const FADE_TIME = .25 

@onready var glow = $glow
@export var selected: bool = false
@export var disabled: bool = false

var _target_alpha = 0.0
var _tween_alpha = 0.0
var _glow_tween: Tween

func _process(_delta):
	# we aren't initialized yet, do nothing
	if not glow:
		return
	
	# figure out if we should be on or off
	if not selected or disabled:
		_target_alpha = 0.0
	else:
		_target_alpha = 1.0
	
	# if we are already there, do nothing
	if _target_alpha == glow.modulate.a:
		return
	
	# otherwise start heading in the right direction
	_tween_glow()
	
func _tween_glow():
	# if our current tween is already heading in the right direction, we don't need to do anything
	if _tween_alpha == _target_alpha:
		return
	
	# dispose of any existing tween and recreate it
	if _glow_tween:
		_glow_tween.kill()
		_glow_tween = null
	_glow_tween = create_tween()
		
	# figure out how fast we should fade
	var _time = abs(_target_alpha - glow.modulate.a) * FADE_TIME
	
	# kick off the new effect
	_glow_tween.tween_property(glow, "modulate:a", _target_alpha, _time) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)

	# keep track of which direction the current tween is heading
	_tween_alpha = _target_alpha
	

func _ready():
	add_to_group("selectables")

func interact():
	emit_signal("interacted")
