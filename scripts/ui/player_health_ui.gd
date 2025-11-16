extends Control

@export var player: Node2D
@export var heart_scene: PackedScene
@onready var hearts = $Hearts

@export var hearts_per_bar: int = 10

var health: Health

# Called when the node enters the scene tree for the first time.
func _ready():
	health = player.get_node("Health") as Health
	health.health_changed.connect(_on_health_changed)
	_on_health_changed(health.current_health, health.max_health)

func rebuild_hearts(max_hearts: int):
	for h in hearts.get_children():
		h.queue_free()
	
	for i in max_hearts:
		var heart = heart_scene.instantiate()
		hearts.add_child(heart)

func _on_health_changed(_current, _max):
	var max_hearts = int(ceil(_max / float(hearts_per_bar)))
	var full_hearts = int(ceil(_current / float(hearts_per_bar)))
	
	if max_hearts != hearts.get_child_count():
		rebuild_hearts(max_hearts)
	
	# Wait for heart nodes to sort themselves out
	await get_tree().process_frame
	
	var i = 0
	for h in hearts.get_children():
		if i < full_hearts:
			h.fade_in()
		else:
			h.fade_out()
		i += 1
