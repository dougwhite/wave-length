class_name DialogueSpeaker
extends RefCounted

var speaker_name: StringName
var color: Color

func _init(_speaker_name: StringName = "", _color: Color = Color.WHITE) -> void:
	speaker_name = _speaker_name
	color = _color

func say(_text: String = "") -> DialogueMessage:
	return DialogueMessage.new(_text, speaker_name, color)
