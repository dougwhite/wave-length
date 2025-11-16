extends Control

@export var player: Node2D
@export var heart_scene: PackedScene
@onready var hearts = $Hearts

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
	rebuild_hearts(_current / 10)
