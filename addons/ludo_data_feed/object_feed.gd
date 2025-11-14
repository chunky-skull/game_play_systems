class_name ObjectLudoDataFeed
extends LudoDataFeed

func _init(initial_value : Object, subscriber : LudoDataFeed = null) -> void:
	super._init(subscriber)
	value = initial_value

var value : Object:
	set(new_value):
		value.disconnect.call()
		value = new_value
		if value != null and value is LudoDataFeed:
			value.update_broadcast.connect(_forward_broadcast)
		broadcast()
		return value
