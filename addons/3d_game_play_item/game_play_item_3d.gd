class_name GamePlayItem3D extends Resource

var database_index : int
@export var label : String
@export var type : String
@export var weight : float
@export var can_equip : bool = true
@export var can_use : bool = true
@export var description: String
@export var mesh: Mesh
@export var icon: Texture2D
@export var effects: Array[ItemEffect]
