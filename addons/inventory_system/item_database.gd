extends Node

class_name ItemDatabase

func _ready() -> void:
	init_items()

func get_item_by_index(item_index) -> Node:
	var item : Node = get_child(item_index)
	return item

func init_items() -> void:
	var index : int = 0
	for item in get_children():
		item.database_index = index
		index += 1
