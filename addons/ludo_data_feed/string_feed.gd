class_name StringLudoDataFeed
extends LudoDataFeed

func _init(initial_value : String, subscriber : LudoDataFeed = null) -> void:
	super._init(subscriber)
	value = initial_value

var value : String:
	set(v):
		value = v
		update_broadcast.emit(self)
		return value
