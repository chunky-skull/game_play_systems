class_name GamePlayItem3DLinkedList extends Resource

var head: GamePlayItem3DLinkedListSlot

func iterate(callback: Callable) -> void:
	var slot = head
	
	while not slot == null:
		callback.call(slot)
		slot = slot.next
	
func iterate_to(is_target: Callable, execute: Callable) -> void:
	var slot = head

	while not _is_tail(slot):
		if is_target.call(slot):
			execute.call(slot)
			return
		slot = slot.next

func _is_tail(slot: GamePlayItem3DLinkedListSlot) -> bool:
	return slot == null

func get_by_index(target_index: int) -> GamePlayItem3DLinkedList:
	var head = self
	var index: int = 0
	var slot = head
	
	while not slot == null:
		if index == target_index:
			return slot
		
		slot = slot.next
		index += 1
	
	return head

func append_item(item: GamePlayItem3D) -> void:
	var slot := head
	var new_slot := GamePlayItem3DLinkedListSlot.new()
	new_slot.item = item
	new_slot.count = 1
	if head == null:
		print_debug("init list")
		head = new_slot
		return
	
	while not _is_tail(slot):
		if slot.item == item:
			slot.count += 1
			return
		if _is_tail(slot.next):
			slot.next = new_slot
			return
		slot = slot.next
	
func remove_by_item( remove_target: GamePlayItem3D, remove_count: int = 1) -> GamePlayItem3DLinkedListSlot:
	var slot: GamePlayItem3DLinkedListSlot = head.next
	if remove_target == head.item:
		head.count -= remove_count
		if head.count <= 0:
			head.next = null
			head = slot
		return head
	
	var previous = head
	var index: int = 1
	while not _is_tail(slot):
		if slot.item == remove_target:
			slot.count -= remove_count
			if slot.count <= 0:
				previous.next = slot.next
				slot.next = null
			return head
		
		previous = slot
		slot = slot.next
		++index
	
	return head
