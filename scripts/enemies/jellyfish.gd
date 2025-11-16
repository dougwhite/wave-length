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

	# figure out where our goal is from our current location
	var dir = (goal.global_position - global_position)
	
	# If we are near our destination, try to damage it
	if dir.length() <= 1.0:
		var goal_health = goal.get_node_or_null("Health")
		if goal_health:
			goal_health.take_damage(10) 
			queue_free()
	
	# Move towards our goal
	position += dir.normalized() * speed * delta
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

# If we collide with something that has a health bar, damage it then queue_free
func _on_body_entered(body):
	var body_health = body.get_node_or_null("Health")
	if body_health:
		body_health.take_damage(10, self) 
		queue_free()
