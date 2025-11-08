class_name DialogueMessage
extends RefCounted

var text: String
var speaker: StringName
var color: Color

func _init(_text: String = "", _speaker: StringName = "", _color: Color = Color.WHITE) -> void:
	text = _text
	speaker = _speaker
	color = _color

func formatted() -> String:
	var msg = text
	if speaker:
		msg = speaker + ": " + msg
	
	return msg
