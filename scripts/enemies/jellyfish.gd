extends Tunable

@onready var alien_noise = $alien_noise

@export var goal: Node2D
@export var speed: float = 50
@export var health: float = 5

func _ready():
	$alien_noise.play()
	super()

func _process(delta):
	if !goal:
		return
		
	var dir = (goal.global_position - global_position).normalized()
	position += dir * speed * delta
	super(delta)

func strong_hit() -> bool:
	return take_damage(5)

func medium_hit() -> bool:
	return take_damage(2)

func weak_hit() -> bool:
	return take_damage(1)

func take_damage(dmg: float):
	health -= dmg
	if health <= 0:
		queue_free()
	
	return true
