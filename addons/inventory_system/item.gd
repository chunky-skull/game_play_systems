extends Node3D

class_name Item



var database_index : int
@export var label : String
@export var type : String
@export var weight : float
@export var can_equip : bool = true
@export var can_use : bool = true
var quantity : int #refactor this out

var item : Dictionary = {
	"graphic" : "Texture2D",
}

func use() -> void:
	pass
	
func equip() -> void:
	pass
