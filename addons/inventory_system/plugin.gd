@tool
extends EditorPlugin
const INVENTORY_AUTOLOAD = "LudoInventory"
const DIRECTORY = "res://addons/inventory_system/controller/inventory_autoload.gd"

func _enable_plugin() -> void:
	add_autoload_singleton(INVENTORY_AUTOLOAD, DIRECTORY)
	pass

func _disable_plugin() -> void:
	remove_autoload_singleton(INVENTORY_AUTOLOAD)
	pass
