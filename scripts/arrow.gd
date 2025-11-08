extends Node2D

@onready var sprite = $Sprite2D

@export var player: Node2D
@export var objective: Node2D

const FLOAT_DIST = 100
const FADE_IN_TIME: float = .15
const FADE_OUT_TIME: float = .15

var _hidden = true

func _ready():
	sprite.modulate.a = 0.0

func _process(_delta):
	# If we have no objective or player, we should hide the arrow
	if objective == null or player == null:
		if not _hidden:
			_fade_out()
		return
	
	# Figure out angle from player to the objective
	var player_center = player.global_position + Vector2(0.0, -55.0)
	var dir: Vector2 = objective.global_position - player_center
	
	# If we are really close, just float the arrow on the object
	if dir.length() < FLOAT_DIST:
		global_position = objective.global_position
	# otherwise put it a set distance away from the player
	else:
		global_position = player_center + dir.normalized() * FLOAT_DIST
	
	# turn the arrow to face the direction of the object
	sprite.rotation = dir.angle()
	
	# if the objective arrow was hidden, fade it in now
	if _hidden:
		_fade_in()

# fades the arrow in
func _fade_in() -> void:
	_hidden = false
	var tween = create_tween()

	tween.tween_property(sprite, "modulate:a", 1.0, FADE_IN_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)

# fades the arrow out
func _fade_out() -> void:
	_hidden = true
	var tween = create_tween()

	tween.tween_property(sprite, "modulate:a", 0.0, FADE_OUT_TIME) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN)
