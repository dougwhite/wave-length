extends Tunable

@onready var alien_noise = $alien_noise
@onready var death_noise = $death_noise
@onready var animation_player = $AnimationPlayer

@export var goal: Node2D
@export var speed: float = 50
@export var health: float = 3

var dead = false

func _ready():
	$alien_noise.play()
	super()

func _process(delta):
	if !goal or dead:
		return

	# figure out where our goal is from our current location
	var dir = (goal.global_position - global_position)
	
	# If we are near our destination, try to damage it
	if dir.length() <= 1.0:
		var goal_health = goal.get_node_or_null("Health")
		if goal_health:
			dead = true
			goal_health.take_damage(10, self) 
			animation_player.play("explode")
	
	# Move towards our goal
	position += dir.normalized() * speed * delta
	super(delta)

func strong_hit() -> bool:
	return take_damage(5)

func medium_hit() -> bool:
	return take_damage(2)

func weak_hit() -> bool:
	return take_damage(1)

func any_hit() -> void:
	death_noise.play() 

func take_damage(dmg: float):
	health -= dmg
	if health <= 0:
		dead = true
		animation_player.play("die")
	
	return true

# If we collide with something that has a health bar, damage it then queue_free
func _on_body_entered(body):
	var body_health = body.get_node_or_null("Health")
	if body_health:
		body_health.take_damage(10, self) 
		dead = true
		queue_free()
