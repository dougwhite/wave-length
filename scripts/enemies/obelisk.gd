extends Interactable

@export var band: int = 0
@export var match_band: bool = true
@export var wave_manager: Node
@export var goal: Node2D
@export var game_manager: GameManager

@onready var runes = $runes
@onready var animation_player = $AnimationPlayer

# spawn_1..spawn_12 Node2D
@onready var spawn_points = $SpawnPoints

var jellyfish = preload("res://scenes/enemies/jellyfish.tscn")
const SPAWN_DELAY: float = 4.0

var spawn_timer: float = 0.0
var dead: bool = false

# Match our runes color to the type of jellyfish we'll spit out 
func _ready():
	if match_band:
		runes.modulate = game_manager.frequency_color(band)
	super()

# Interacting destroys the obelisk
func _on_interacted():
	animation_player.play("explode")
	dead = true

# Periodically summon jellyfish
func _process(delta):
	if dead:
		return
	
	spawn_timer += delta
	if spawn_timer > SPAWN_DELAY:
		spawn_jellyfish()
		spawn_timer = 0

	super(delta)

func spawn_jellyfish():
	if dead:
		return
	# Spawn the jellyfish using our enemy wave manager parent
	# func _spawn_mob(asset: PackedScene, spawn_path: NodePath, goal_path: NodePath, band: int = -1):
	wave_manager._spawn_mob(jellyfish, _node2path(_get_random_spawn()), _node2path(goal), band)

# Gets a random spawn point from spawn_points
func _get_random_spawn() -> Node2D:
	var spawns = spawn_points.get_children()
	var index: int = randi() % spawns.size()
	return spawns[index] as Node2D

# Converts a node into it's node path
func _node2path(node: Node) -> NodePath:
	if node == null:
		return NodePath("")
	return node.get_path()
