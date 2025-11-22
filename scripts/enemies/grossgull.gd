extends Tunable

enum State { CRUISE, SWOOP, OVERSHOOT, RECOVER }

@onready var swoop_noise = $swoop_noise
@onready var death_noise = $death_noise
@onready var null_noise = $null_noise
@onready var animation_player = $AnimationPlayer

@export var goal: Node2D # Should always be player
@export var health: float = 10

# CRUISE SETTINGS
@export var cruise_speed: float = 200
@export var cruise_duration: float = 4.0
@export var cruise_engage_dist: float = 350.0

# SWOOP SETTINGS
@export var swoop_speed: float = 650

# OVERSHOOT SETTINGS
@export var overshoot_duration: float = 0.5

# RECOVER SETTINGS
@export var recover_speed: float = 80.0
@export var recover_safe_x: float = 100.0
@export var recover_height_min: float = 300.0
@export var recover_height_max: float = -300.0
@export var recover_min_duration: float = 2.0

var state: State = State.CRUISE
var state_time: float = 0.0
var fly_direction: float = 1.0	# 1 = right, -1 = left
var swoop_dir: Vector2 = Vector2.ZERO
var recover_target_y: float = 0.0
var base_sprite_modulate: Color
var base_glow_modulate: Color

var dead = false

func _ready():
	# Call the tunable superclass _ready()
	super()
	
	# If for some reason we don't have a goal, go get the player as our goal
	if goal == null:
		goal = get_tree().get_first_node_in_group("player") as Node2D
	
	# Store our original color
	base_sprite_modulate = sprite.modulate
	base_glow_modulate = glow.modulate
	
	# Start in cruise state
	change_state(State.CRUISE)

func _process(delta):
	state_time += delta
	
	if fly_direction == 1:
		sprite.flip_h = false
		glow.flip_h = false
	else:
		sprite.flip_h = true
		glow.flip_h = true
	
	match state:
		State.CRUISE:
			update_cruise(delta)
		State.SWOOP:
			update_swoop(delta)
		State.RECOVER:
			update_recover(delta)
		State.OVERSHOOT:
			update_overshoot(delta)

	super(delta)

func change_state(new_state: State):
	if state == new_state:
		return
	
	state = new_state
	state_time = 0.0
	
	match state:
		State.CRUISE:
			enter_cruise()
		State.SWOOP:
			enter_swoop()
		State.RECOVER:
			enter_recover()
		State.OVERSHOOT:
			enter_overshoot()

func enter_cruise():
	sprite.modulate = base_sprite_modulate
	glow.modulate = base_glow_modulate
	
	glow.play("cruise")
	sprite.play("cruise")
	
func update_cruise(delta):
	if !goal or dead:
		return

	# If we've been in this state for too long, SWOOP
	if state_time >= cruise_duration:
		change_state(State.SWOOP)
		return

	# Calculate the x distance between us and player
	var dx := goal.global_position.x - global_position.x

	# Work out which x direction to travel
	fly_direction = sign(dx)

	# If we are too close to player, SWOOP
	if fly_direction == 0 or abs(dx) <= cruise_engage_dist:
		change_state(State.SWOOP)
		return

	# Fly horizontally
	global_position.x += fly_direction * cruise_speed * delta
	
func enter_swoop():
	glow.play("swoop")
	sprite.play("swoop")
	swoop_noise.play()
	
	# Determine a vector to swoop at
	swoop_dir = (goal.global_position - global_position).normalized()
	fly_direction = sign(swoop_dir.x)

func update_swoop(delta):
	global_position += swoop_dir * swoop_speed * delta
	
	# Figure out a line to the goal 
	var to_goal = goal.global_position - global_position
	
	# We overshot the goal, start overshoot state
	if swoop_dir.dot(to_goal) <= 0.0:
		change_state(State.OVERSHOOT)
		return

func enter_overshoot():
	pass

func update_overshoot(delta):
	if state_time >= overshoot_duration:
		change_state(State.RECOVER)
		return

	global_position += swoop_dir * swoop_speed * delta

func enter_recover():
	glow.play("cruise")
	sprite.play("cruise")

	# figure out direction opposite to player
	var dx = global_position.x - goal.global_position.x
	fly_direction = sign(dx)
	
	# If they are exactly below us, just fly right
	if fly_direction == 0.0:
		fly_direction = 1.0
	
	# Pick a random y offset to fly to
	var offset_y = randf_range(recover_height_max, recover_height_min)
	recover_target_y = goal.global_position.y + offset_y
	
func update_recover(delta):
	# Visual effect to let player know we are vulnerable
	var pulse = 0.5 + 0.5 * sin(state_time * 15)
	var alpha = lerp(0.3, 1.0, pulse)
	sprite.modulate.a = alpha
	# glow.modulate.a = alpha
	
	# Vertical recovery component
	var dy = recover_target_y - global_position.y
	var vy = clamp(dy, -1.0, 1.0) * recover_speed
	
	# Horizontal movement away from player component
	var vx = fly_direction * recover_speed
	
	# Update position
	global_position += Vector2(vx, vy) * delta
	
	# Once we are roughly at our recovery height, and far enough away
	# return to CRUISE
	var close_enough_y = abs(dy) < 4.0
	var far_enough_x = abs(global_position.x - goal.global_position.x) > recover_safe_x
	var time_enough = state_time > recover_min_duration 
	if close_enough_y and far_enough_x and time_enough:
		fly_direction = -fly_direction
		change_state(State.CRUISE)

func strong_hit() -> bool:
	return take_damage(5)

func medium_hit() -> bool:
	return take_damage(4)

func weak_hit() -> bool:
	return take_damage(3)

func take_damage(dmg: float):
	# Ghost gulls are only hittable when alive
	if dead:
		return false
	
	# Ghost gulls are only hittable while in recovery
	if state != State.RECOVER:
		null_noise.play()
		return false

	death_noise.play() 

	health -= dmg
	if health <= 0:
		dead = true
		animation_player.play("die")

	return true

# If we collide with something that has a health bar, damage it then queue_free
func _on_body_entered(body):
	var body_health = body.get_node_or_null("Health")
	if body_health:
		# Don't do anything if player is dodge rolling
		if body_health.invulnerable:
			return
		body_health.take_damage(10, self) 
