extends RayCast3D

@export var point_of_view: Node3D

#func _ready() -> void:
	#match_point_of_view_position()
	#match_point_of_view_basis()

func _process(delta: float) -> void:
	match_point_of_view_basis()
	#match_point_of_view_position()
	
func match_point_of_view_position() -> void:
	position = point_of_view.position

func match_point_of_view_basis() -> void:
	global_transform.basis = point_of_view.global_basis
