@abstract
class_name scannable extends Node

@export var collision_shape : CollisionShape3D
@export var scan_collision_level : int = 3
@export var scan_time : float = 1.0

var scan_data : Dictionary = {
	"entry" : "long text about the scannable item that is available in the scan data list menu",
	"label" : "A label or title for the data entry",
	"graphic" : "Texture2D"
}

func _ready() -> void:
	_init_scanner_collision_level()

func _init_scanner_collision_level() -> void:
	collision_shape.set_collision_layer_value(scan_collision_level, true)
	collision_shape.set_collision_mask_value(scan_collision_level, true)
	collision_shape.set_collision_layer_value(1, false)
	collision_shape.set_collision_mask_value(1, false)
