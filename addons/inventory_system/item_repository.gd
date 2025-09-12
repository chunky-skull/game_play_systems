extends Node

class_name ItemRepository
@export var database : Node 
var item_database_indices := ItemLinkedList.new()

func _ready() -> void:
	init_item_database_indices()

func init_item_database_indices() -> void:
	var head = item_database_indices.init_new_node(0)
	var node4 = item_database_indices.init_new_node(3)
	var tail : Dictionary
	var count : int = 0
	
	item_database_indices.head = head
	
	while count < 5:
		count += 1
		var new_node = item_database_indices.init_new_node(count)
		item_database_indices.add_item(new_node.database_index)
		tail = new_node

	item_database_indices.tail = tail
	item_database_indices.add_item(node4.database_index)
	#item_database_indices.remove_by_database_index(0)
	var node = head
	
	while not node == null:
		print(node.database_index, " ", node.quantity)
		node = node.next

func add_item_database_index(item_database_index:int) -> void:
	item_database_indices.add_item(item_database_index)

func remove_item_by_database_index(item_database_index:int) -> void:
	item_database_indices.remove_by_database_index(item_database_index)

func get_item_by_database_index(item_database_index:int) -> Node:
	var item = database.get_item_by_index(item_database_index)
	return item

func get_all_items() -> Array[Node]:
	var all_items : Array[Node] 
	var item : Node
	var call_back := func(node):
		item = get_item_by_database_index(node.database_index)
		item.quantity = node.quantity
		all_items.append(item)
	
	item_database_indices.iterate(call_back)

	return all_items
	
