extends Area3D

@onready var shape: CollisionShape3D = $CollisionShape3D
@onready var timer: Timer = $Timer

@export var scan_input_label : String = "scan"

var target

signal scanned(scan_data)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	timer.timeout.connect(_on_timer_timeout)
	_disable_scanner_area()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(scan_input_label):
		_enable_scanner_area()
		return
	if Input.is_action_just_released(scan_input_label):
		_disable_scanner_area()
		timer.stop()
		return

func _on_body_entered(body) -> void:
	timer.wait_time = body.scan_data.scan_time
	target = body
	timer.start()
	
func _on_body_exited(body) -> void:
	target = null
	timer.stop()

func _on_timer_timeout() -> void:
	emit_signal("scanned", target.scan_data)
	#a way disable target from being scanned again
	#target.set_collision_layer_value(scan_collision_level, false)

func _enable_scanner_area() -> void:
	shape.disabled = false

func _disable_scanner_area() -> void:
	shape.disabled = true

func init_scanner_collision_level(scan_collision_level) -> void:
	set_collision_layer_value(scan_collision_level, true)
	set_collision_mask_value(scan_collision_level, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
