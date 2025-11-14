class_name LudoDataFeed
extends Resource

var disconnect_forwarding : Callable = func(): return

signal update_broadcast(data_feed: LudoDataFeed)

func _forward_broadcast(_data_feed: LudoDataFeed) -> void:
	broadcast()

func _init(parent_feed: LudoDataFeed = null) -> void:
	if parent_feed != null:
		set_forwarding_connection(parent_feed)

func set_forwarding_connection(parent_feed: LudoDataFeed) -> void:
	disconnect_forwarding.call()
	update_broadcast.connect(parent_feed._forward_broadcast)
	disconnect_forwarding = func():
		update_broadcast.disconnect(parent_feed._forward_broadcast)

func broadcast() -> void:
	update_broadcast.emit(self)

func manual_broadcast() -> void:
	broadcast()
