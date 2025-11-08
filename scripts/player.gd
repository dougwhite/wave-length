extends CharacterBody2D

var input_enabled = true

@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 300.0
var last_dir = 1 	# 0 - right, 1 - left, 2 - down, 3 - up

func _physics_process(_delta):
	
	if not input_enabled:
		return;

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	direction = Input.get_axis("move_up", "move_down")
	if direction:
		velocity.y = direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if velocity.length() > 0:
		if velocity.x > 0:
			animated_sprite.play("walk_right")
			last_dir = 0
		elif velocity.x < 0:
			animated_sprite.play("walk_left")
			last_dir = 1
		elif velocity.y > 0:
			animated_sprite.play("walk_down")
			last_dir = 2
		elif velocity.y < 0:
			animated_sprite.play("walk_up")
			last_dir = 3
		
	else:
		if last_dir == 0:
			animated_sprite.play("idle_right")
		elif last_dir == 1:
			animated_sprite.play("idle_left")
		elif last_dir == 2:
			animated_sprite.play("idle_down")
		elif last_dir == 3:
			animated_sprite.play("idle_up")
			
	move_and_slide()
