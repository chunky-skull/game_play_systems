class_name ReactiveObject
extends ReactiveData

var value : Object:
	set(new_value):
		if value != null and value is ReactiveData:
			value.react.disconnect_forwarding()
		value = new_value
		if value != null and value is ReactiveData:
			value.react.set_forwarding_connection(self)
		react.manual_broadcast()
		return value

func _init(init_value: Object, parent_feed = null) -> void:
	react = ReactiveFeed.new(self, parent_feed)
	value = init_value
