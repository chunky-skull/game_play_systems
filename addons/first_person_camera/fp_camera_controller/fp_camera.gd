extends Node3D
@export var x_sense : float
@export var y_sense : float
@export var max_y_clamp : float = 1.87
@export var min_y_clamp : float = 0.62
@onready var input: MouseMotionCollector = MouseMotionCollector.new()
@onready var camera_mount: Node3D = $FPCameraMount
@onready var camera: Camera3D = $FPCameraMount/YPivot/XPivot/Camera3D
@onready var y_pivot: Node3D = $FPCameraMount/YPivot
@onready var x_pivot: Node3D = $FPCameraMount/YPivot/XPivot

var rotation_vector : Vector2 = Vector2.ZERO

func update(delta) -> void:
	rotation_vector.y += -(input.mouse_motion.x) * delta
	var x_rotation = x_pivot.rotation.x + (input.mouse_motion.y * delta)
	rotation_vector.x = clamp(x_rotation, PI/-3, PI/2)
	x_pivot.rotation.x = rotation_vector.x
	input.mouse_motion = Vector2.ZERO
		
func _unhandled_input(event: InputEvent) -> void:
	input.collect(event)

# create a fp_camera_juice class to hold all the methods for juicing up the camera.
