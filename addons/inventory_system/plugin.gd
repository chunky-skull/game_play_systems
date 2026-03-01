@tool
extends EditorPlugin
const INVENTORY_AUTOLOAD = "ludo_inventory"
const DIRECTORY = "res://addons/inventory_system/controller/inventory_controller.gd"

func _enter_tree() -> void:
	#add_autoload_singleton(INVENTORY_AUTOLOAD, DIRECTORY)
	pass


func _exit_tree() -> void:
	#remove_autoload_singleton(INVENTORY_AUTOLOAD)
	pass
