class_name ScanDataLinkedList extends Object

var next

var data
var label

func get_by_index(head, target_index: int) -> Node:
	var index: int = 0
	var node = head
	
	while not node.next == null:
		if index == target_index:
			return node
		
		node = node.next
		++index
	
	return head

func append(head, new_node) -> ScanDataLinkedList:
	var node = head
	
	if head.next == null:
		head.next = new_node
		return head
	
	while not node.next == null:
		node = node.next
	
	node.next = new_node
	return head
	
func remove(head, remove_index: int) -> Node:
	var previous = head
	var index: int = 0
	var node = head
	
	if remove_index == 0:
		node = head.next
		head.next = null
		return node
	
	while not node.next == null:
		if index == remove_index:
			previous.next = node.next
			node.next = null
			return head
		
		previous = node
		node = node.next
		++index
	
	return head
