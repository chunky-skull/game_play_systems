@tool
extends EditorPlugin


func _enter_tree() -> void:
	#add_custom_type("MoveSet", "Node", preload("./movement_state_machine/move_set.gd"), preload("./icons/chunky_skull_logo_icon.png"))
	#add_custom_type("MoveModel", "Node", preload("./movement_model/move_model.gd"), preload("./icons/chunky_skull_logo_icon.png"))
	#add_custom_type("Move", "Node", preload("./movement_state_machine/move.gd"), preload("./icons/chunky_skull_logo_icon.png"))
	pass

func _exit_tree() -> void:
	#remove_custom_type("MoveModel")
	#remove_custom_type("MoveSet")
	#remove_custom_type("Move")
	pass
