class_name ReactiveFeed
extends Resource

#need to figure out a way to begin testing all this code

var _disconnect_forwarding : Callable = func() -> void: return

var _broadcast : Callable

signal update_broadcast(data_feed: ReactiveData)

func _forward_broadcast(reactive_data: ReactiveData) -> void:
	update_broadcast.emit(reactive_data)

func _init(reactive_data, parent_feed: ReactiveData = null) -> void:
	_broadcast = func() -> void: update_broadcast.emit(reactive_data)
	if parent_feed != null:
		set_forwarding_connection(parent_feed)

func set_forwarding_connection(parent_feed: ReactiveData) -> void:
	disconnect_forwarding()
	update_broadcast.connect(parent_feed.react._forward_broadcast.bind(parent_feed))
	_disconnect_forwarding = func() -> void:
		update_broadcast.disconnect(parent_feed._forward_broadcast.bind(parent_feed))

func manual_broadcast() -> void:
	_broadcast.call()

func disconnect_forwarding() -> void:
	_disconnect_forwarding.call()
