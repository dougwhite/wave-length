extends Area2D

@onready var sprite = $wave_sprite

@export var speed: float = 600.0
@export var lifetime: float = 1.5
@export var color: Color = Color.WHITE
@export var band: int = 0
@export var grow_percent: float = 4.0
@export var fade_percent: float = 0.0
@export var strength_percent: float = 0.5

var velocity: Vector2 = Vector2.UP
var elapsed = 0.0
var current_strength = 1.0

func _ready():
	sprite.modulate = color
	velocity = velocity * speed
	rotation = velocity.angle() + PI / 2.0
	create_effect_tween()

func create_effect_tween():
	var tween = create_tween()
	var grow_vec = Vector2(grow_percent, grow_percent)
	
	tween.parallel().tween_property(self, "scale", grow_vec, lifetime) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN)
	
	tween.parallel().tween_property(self, "modulate:a", fade_percent, lifetime) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN)

	tween.parallel().tween_property(self, "current_strength", strength_percent, lifetime) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_IN)
	
func _process(delta): 
	position += velocity * delta
	elapsed += delta
	if elapsed > lifetime:
		queue_free()

func _on_area_entered(area):
	hit_target(area)

func _on_body_entered(body):
	hit_target(body)

func hit_target(target: Node) -> void:
	if target is Tunable:
		if target.hit(band, current_strength):
			queue_free()
