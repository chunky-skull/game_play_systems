class_name ArrayLudoDataFeed
extends LudoDataFeed

var value : Array:
	set(v):
		value = v
		update_broadcast.emit(self)
		return value

func _init(initial_value : Array = []) -> void:
	value = initial_value

func get_at(i : int) -> Variant:
	return value[i]

func set_at(i : int, v : Variant) -> void:
	value[i] = v
	update_broadcast.emit(self)

func append(v : Variant) -> void:
	value.append(v)
	update_broadcast.emit(self)

func append_array(array : Array) -> void:
	value.append_array(array)
	update_broadcast.emit(self)

func assign(array : Array) -> void:
	value.assign(array)
	update_broadcast.emit(self)

func clear() -> void:
	value.clear()
	update_broadcast.emit(self)

func erase(v : Variant) -> void:
	value.erase(v)
	update_broadcast.emit(self)

func insert(position : int, v : Variant) -> void:
	value.insert(position, v)
	update_broadcast.emit(self)

func pop_at(index : int) -> Variant:
	var tmp = value.pop_at(index)
	update_broadcast.emit(self)
	return tmp

func pop_back() -> Variant:
	var tmp = value.pop_back()
	update_broadcast.emit(self)
	return tmp

func pop_front() -> Variant:
	var tmp = value.pop_front()
	update_broadcast.emit(self)
	return tmp

func push_back(v : Variant) -> void:
	append(v)

func remove_at(index : int) -> void:
	value.remove_at(index)
	update_broadcast.emit(self)

func shuffle() -> void:
	value.shuffle()
	update_broadcast.emit(self)

func sort() -> void:
	value.sort()
	update_broadcast.emit(self)

func sort_custom(callable : Callable) -> void:
	value.sort_custom(callable)
	update_broadcast.emit(self)
