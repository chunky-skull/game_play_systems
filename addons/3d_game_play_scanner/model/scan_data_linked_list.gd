class_name ScanDataLinkedList extends Object

var next

var data

func _data():
	return data

func iterate(callback: Callable) -> ScanDataLinkedList:
	var head = self
	var node = head
	
	while not node == null:
		callback.call(node)
		node = node.next
	
	return head
	
func iterate_to(to: Callable, execute: Callable) -> ScanDataLinkedList:
	var head = self
	var node = head
	
	while to.call(node):
		node = node.next
	
	execute.call(node)
	return head

func get_by_index(head:ScanDataLinkedList, target_index: int) -> ScanDataLinkedList:
	var index: int = 0
	var node = head
	
	while not node == null:
		if index == target_index:
			return node
		
		node = node.next
		index += 1
	
	return head

func append(head:ScanDataLinkedList, new_node) -> ScanDataLinkedList:
	var node = head
	
	if head.data == null:
		print_debug("init list")
		#head.next = new_node
		return new_node
	
	while not node.next == null:
		node = node.next
	
	node.next = new_node
	return head
	
func remove(head:ScanDataLinkedList, remove_index: int) -> ScanDataLinkedList:
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
