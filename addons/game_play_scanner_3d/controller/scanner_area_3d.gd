extends Area3D

@export var scan_input_label : String = "scan"
@onready var timer: Timer = $Timer

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
	#timer.wait_time = body.scan_time
	target = body
	timer.start()
	
func _on_body_exited(body) -> void:
	target = null
	timer.stop()

func _on_timer_timeout() -> void:
	print_debug("scanned data: ", target)
	emit_signal("scanned", target)

func _enable_scanner_area() -> void:
	monitorable = true
	monitoring = true

func _disable_scanner_area() -> void:
	monitorable = false
	monitoring = false

func init_scanner_collision_level(scan_collision_level) -> void:
	set_collision_layer_value(scan_collision_level, true)
	set_collision_mask_value(scan_collision_level, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
