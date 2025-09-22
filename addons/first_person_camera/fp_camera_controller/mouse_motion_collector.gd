extends Node
class_name MouseMotionCollector
var mouse_motion := Vector2.ZERO

func collect(event: InputEvent) -> void:
	#print_debug("mouse motion")
	
	var is_mouse_motion := ( event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED )
	if is_mouse_motion:
		mouse_motion = event.screen_relative
