extends Node

class_name ItemLinkedList

var debug_recursive_limit : int = 2000
var debug_recursive_count : int = 0

var head 
var tail

func init_new_node(database_index :int, quantity : int = 1) -> Dictionary:
	var new_node = {
		"database_index" : database_index,
		"quantity" : quantity,
		"next": null
	}
	return new_node
	
func includes(challange_database_index: int, node : Dictionary = head) -> bool:
	if debug_recursive_limit_reached():
		return false
	if node.database_index == challange_database_index:
		debug_recursive_count = 0
		return true
	if node.next == null:
		debug_recursive_count = 0
		return false
	else:
		debug_recursive_count += 1
		return includes(node.next.database_index, node)

func add_item(database_index, node: Dictionary = head) -> void:
	if debug_recursive_limit_reached():
		return
	if node.database_index == database_index:
		node.quantity += 1
		return
	if node.next == null:
		var new_node = init_new_node(database_index)
		node.next = new_node
		tail = new_node
		return
	else:
		add_item(database_index, node.next)


func debug_recursive_limit_reached() -> bool:
	var limit_reached := debug_recursive_count == debug_recursive_limit
	debug_recursive_count = 0
	#print_debug("recursive limit reached")
	return limit_reached
	

func remove_by_database_index(database_index : int, node : Dictionary = head) -> void:
	var previous_node : Dictionary
	if head.database_index == database_index:
		if head.quantity > 1:
			head.quantity -= 1
			return
		head = head.next
		return
	while not node == null:
		if node.database_index == database_index:
			if node.quantity > 1:
				node.quantity -= 1
				return
			previous_node.next = node.next
			if previous_node.next == null:
				tail = previous_node
			return
		previous_node = node
		node = node.next

func iterate(call_back : Callable)-> void:
	var node = head
	while not node == null:
		call_back.call(node)
		node = node.next

func iterate_to(to_conditional: Callable, execute: Callable)-> void:
	var node = head
	var loop_count := 0
	while not to_conditional.call(node):
		node = node.next
		if loop_count > 100:
			return
		loop_count += 1
	execute.call(node)
		
func get_tail(node: Dictionary = head) -> Dictionary:
	if node.next == null:
		return node
	else:
		return get_tail(node.next)
