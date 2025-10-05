class_name GamePlayItem3DLinkedList extends Resource

var next
var item: GamePlayItem3D
var count: int

func iterate(callback: Callable) -> GamePlayItem3DLinkedList:
	var head = self
	var node = head
	
	while not node == null:
		callback.call(node)
		node = node.next
	
	return head
	
func iterate_to(to: Callable, execute: Callable) -> GamePlayItem3DLinkedList:
	var head = self
	var node = head
	
	while to.call(node):
		node = node.next
	
	execute.call(node)
	return head

func get_by_index(target_index: int) -> GamePlayItem3DLinkedList:
	var head = self
	var index: int = 0
	var node = head
	
	while not node == null:
		if index == target_index:
			return node
		
		node = node.next
		index += 1
	
	return head

func append( new_node) -> GamePlayItem3DLinkedList:
	var head = self
	var node = head
	
	if head.item == null:
		print_debug("init list")
		#head.next = new_node
		return new_node
	
	while not node.next == null:
		node = node.next
	
	node.next = new_node
	return head
	
func remove( remove_index: int) -> GamePlayItem3DLinkedList:
	var head = self
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
