class_name LinkedListFeed
extends LudoDataFeed
var value

func iterate(callback: Callable) -> void:
	value.iterate(callback)
	update_broadcast.emit(self)

func iterate_to(is_target: Callable, execute: Callable) -> void:
	value.iterate_to(is_target, execute)
	update_broadcast.emit(self)

func append_item(item: GamePlayItem3D) -> void:
	value.append_item(item)
	update_broadcast.emit(self)

func remove_by_item( remove_target: GamePlayItem3D, remove_count: int = 1) -> void:
	value.remove_by_item(remove_target, remove_count)
	update_broadcast.emit(self)
