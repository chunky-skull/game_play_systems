extends CharacterBody3D
@onready var move_label: Label = $DebugUI/MoveLabel
@onready var move_model: MoveModel = $Movement/MoveModel
@onready var fp_camera: Node3D = $FPCamera
@export var debug := false

@export var scanner: Node
#@onready var interactive_ray_cast_3d: RayCast3D = $FPCamera/InteractiveRayCast3D

func _ready() -> void:
	scanner.reparent(fp_camera.x_pivot)
	#interactive_ray_cast_3d.point_of_view = fp_camera.x_pivot
	#interactive_ray_cast_3d.match_point_of_view_position()
	#interactive_ray_cast_3d.match_point_of_view_basis()

func _physics_process(delta: float) -> void:
	#move_model.camera_basis = fp_camera.basis
	move_label.text = move_model.move_set.current_move.label + " " + str(fp_camera.input.mouse_motion)
	var input = move_model.inputCollector.collect_inputs()
	fp_camera.update(delta)
	pivot(fp_camera.rotation_vector)
	move_model.move_set.update(input, delta)
	input.queue_free()

func pivot(rotation_vector : Vector2) -> void:
	var y_rotation := Vector3(0.0, rotation_vector.y, 0.0)
	global_transform.basis = Basis.from_euler(y_rotation)
