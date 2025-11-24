extends Interactable

@export var band: int = 0
@export var match_band: bool = true
@export var wave_manager: Node
@export var goal: Node2D
@export var game_manager: GameManager

@onready var runes = $runes

func _ready():
	if match_band:
		runes.modulate = game_manager.frequency_color(band)
	super()



func _on_interacted():
	pass # Replace with function body.
