extends Control

@onready var full = $FullSprite

const FADE_IN_TIME = 0.25
const FADE_OUT_TIME = 0.25

func fade_in():
	var tween = create_tween()
	tween.tween_property(full, "modulate:a", 1.0, FADE_OUT_TIME) \
		 .set_trans(Tween.TRANS_SINE) \
		 .set_ease(Tween.EASE_IN)
	
func fade_out():
	var tween = create_tween()
	tween.tween_property(full, "modulate:a", 0.0, FADE_OUT_TIME) \
		 .set_trans(Tween.TRANS_SINE) \
		 .set_ease(Tween.EASE_OUT)
