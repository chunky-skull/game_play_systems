class_name ItemDatabase extends Node

#refactor to use DirAccess to get all the filename as a stirng in a PackedStringArray
# That PackedStringArray will be the database.
# Each file will be a custom resource. 
# use a function to give each item resource an ID which is the resource's filename PackedStringArray index

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
