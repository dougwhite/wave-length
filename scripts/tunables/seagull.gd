extends Tunable

signal seagull_flee

@onready var squak_noise = $squak_noise

@export var escape_vector = Vector2.RIGHT
@export var seagull_speed = 500
@export var escape_lifetime = 5
@export var hittable = false

var flying = false
var elapsed = 0

func any_hit() -> void:
	if !hittable:
		return

	# Play a nice annoyed audio
	squak_noise.play()
	
	# Turn off the hittable flag
	hittable = false
	
	# Play the take off animation
	glow.play("take_off")
	sprite.play("take_off")

	# Wait for the take off animation to finish
	await sprite.animation_finished
	
	# Let the narrative engine know they successfully cleared the seagull
	emit_signal("seagull_flee")
	
	# Start flying away
	flying = true
	glow.play("fly")
	sprite.play("fly")

func _process(delta):
	# process glow effects
	super._process(delta)
	
	if not hittable:
		glow.modulate.a = 0.0
	
	# We don't need to do anything until we start flying
	if not flying:
		return
	
	# Fly away at a steady rate
	position += escape_vector * seagull_speed * delta
	
	# Remove from the scene once we get out of range
	elapsed += delta
	if elapsed > escape_lifetime:
		queue_free()
