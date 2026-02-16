class_name ReactiveArray
extends ReactiveData

var value: Array:
	set(new_value):
		value = new_value
		react.update_broadcaset.emit(self)

func _init(init_value:Array, parent_feed = null) -> void:
	react = ReactiveFeed.new(self, parent_feed)
	value = init_value
	
func get_at(index : int) -> Variant:
	return value[index]

func set_at(index : int, array_value : Variant) -> void:
	value[index] = array_value
	react.update_broadcast.emit(self)

func append(array_value : Variant) -> void:
	value.append(array_value)
	react.update_broadcast.emit(self)

func append_array(array : Array) -> void:
	value.append_array(array)
	react.update_broadcast.emit(self)

func assign(array : Array) -> void:
	value.assign(array)
	react.update_broadcast.emit(self)

func clear() -> void:
	value.clear()
	react.update_broadcast.emit(self)

func erase(array_value : Variant) -> void:
	value.erase(array_value)
	react.update_broadcast.emit(self)

func insert(position : int, array_value : Variant) -> void:
	value.insert(position, array_value)
	react.update_broadcast.emit(self)

func pop_at(index : int) -> Variant:
	var tmp = value.pop_at(index)
	react.update_broadcast.emit(self)
	return tmp

func pop_back() -> Variant:
	var tmp = value.pop_back()
	react.update_broadcast.emit(self)
	return tmp

func pop_front() -> Variant:
	var tmp = value.pop_front()
	react.update_broadcast.emit(self)
	return tmp

func push_back(array_value : Variant) -> void:
	append(array_value)

func remove_at(index : int) -> void:
	value.remove_at(index)
	react.update_broadcast.emit(self)

func shuffle() -> void:
	value.shuffle()
	react.update_broadcast.emit(self)

func sort() -> void:
	value.sort()
	react.update_broadcast.emit(self)

func sort_custom(callable : Callable) -> void:
	value.sort_custom(callable)
	react.update_broadcast.emit(self)
