extends Node

class_name InteractInputCollector

func pressed() -> bool:
	return Input.is_action_just_pressed("interact")
