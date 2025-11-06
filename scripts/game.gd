extends Node2D

@onready var player = $Objects/Player
@onready var camera_2d = $Objects/Player/Camera2D
@onready var title = $Title
@onready var dialog_box = $CanvasLayer/DialogBox

var _harry_standing = false
var _intro_finished = false

func _ready():
	# Disable the player input when we first get into the game
	player.input_enabled = false

# On Title node releasing / fading out, we can start the game
func _on_title_start_game() -> void:
	
	# Create a tween for the camera position to center it on the player
	var tween = create_tween()
	tween.tween_property(camera_2d, "position", Vector2(0, -64.0), 1.0) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_OUT)
	await tween.finished

	var messages: Array[String] = ["...Wake up Harry"]
	dialog_box.start(messages)

func _on_dialog_box_dialogue_finished():
	if _intro_finished:
		return
		
	if not _harry_standing:
		player.animated_sprite.play("idle_down")
		
		var messages: Array[String] = [
			"Harry: Oh man... What time is it?", 
			"Harry: I'd better head back to the tower"
		]
		dialog_box.start(messages)
		_harry_standing = true
		return
	
	# Re-enable player input
	player.input_enabled = true	
	_intro_finished = true
