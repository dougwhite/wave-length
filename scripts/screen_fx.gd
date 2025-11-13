extends CanvasLayer

@onready var fade = $FadeRect
@onready var sky = $SkyEvent
@onready var tear = $SkyEvent/Tear

@export var camera: Camera2D

var _shake_tween: Tween
var _sky_tween: Tween

func _ready():
	fade.modulate.a = 0.0
	sky.modulate.a = 0.0

func shake(duration: float = 1.0, strength: float = 200.0, steps: int = 12) -> void:
	if _shake_tween:
		_shake_tween.kill()
	
	var _original_camera_pos = camera.global_position

	_shake_tween = create_tween()
	_shake_tween.set_trans(Tween.TRANS_SINE)
	_shake_tween.set_ease(Tween.EASE_OUT)
	
	var step_time = duration / float(steps)
	
	for i in steps:
		var camera_offset = Vector2(
			randf_range(-strength, strength),
			randf_range(-strength, strength)
		)
		_shake_tween.tween_property(
			camera,
			"global_position",
			_original_camera_pos + camera_offset,
			step_time
		)

	_shake_tween.tween_property(
		camera,
		"global_position",
		_original_camera_pos,
		step_time
	)
	
	await _shake_tween.finished

	
func show_sky_animation(black_in: float = 0.6, sky_in: float = 0.6, sky_out: float = 0.6, black_out: float = 0.6):
	# Clear any existing tween
	if _sky_tween:
		_sky_tween.kill()

	# Fade to black, fade in sky
	_sky_tween = create_tween()
	_sky_tween.tween_property(fade, "modulate:a", 1.0, black_in) \
			  .set_trans(Tween.TRANS_SINE) \
			  .set_ease(Tween.EASE_IN)
	
	_sky_tween.tween_property(sky, "modulate:a", 1.0, sky_in) \
			  .set_trans(Tween.TRANS_SINE) \
			  .set_ease(Tween.EASE_IN)
	
	await _sky_tween.finished
	
	# Play the sky rip animation
	tear.play("tear_1")
	await tear.animation_finished
	
	# Fade back out
	_sky_tween = create_tween()
	_sky_tween.tween_property(sky, "modulate:a", 0.0, sky_out) \
			  .set_trans(Tween.TRANS_SINE) \
			  .set_ease(Tween.EASE_IN)
	
	_sky_tween.tween_property(fade, "modulate:a", 0.0, black_out) \
			  .set_trans(Tween.TRANS_SINE) \
			  .set_ease(Tween.EASE_IN)
	
	await _sky_tween.finished
