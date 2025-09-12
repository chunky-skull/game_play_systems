extends Node3D

class_name Item

signal use_item(item:Item)
signal equip_item(item:Item)

var database_index : int
@export var label : String
@export var type : String
@export var weight : float
var quantity : int

var item : Dictionary = {
	"list_index" : 1,# index number for the ItemList UI element
	"graphic" : "Texture2D",
	"scene" : "either a path or this is equivalent to 'self'..."
}

func use() -> void:
	print_debug("use")
	emit_signal("use_item", self)
	
func equip() -> void:
	print_debug("equip")
	emit_signal("equip_item", self)
