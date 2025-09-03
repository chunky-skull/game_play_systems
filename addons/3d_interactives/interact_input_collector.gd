extends Node

func pressed() -> bool:
	return Input.is_action_just_pressed("interact")
