class_name IntLudoDataFeed
extends LudoDataFeed

func _init(initial_value : int, subscriber : LudoDataFeed = null) -> void:
	super._init(subscriber)
	value = initial_value

var value : int:
	set(v):
		value = v
		update_broadcast.emit(self)
		return value
