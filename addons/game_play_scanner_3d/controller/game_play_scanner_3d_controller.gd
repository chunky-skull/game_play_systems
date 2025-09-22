extends Node3D

@export var scan_input_label : String = "scan"
@export var scan_collision_level : int = 3
@export var scan_data_menu : Control
@export var scan_data_repo : Node
@export var area3D : Area3D
@export var timer : Timer

var target

signal scanned(scan_data)

func _ready() -> void:
	area3D.body_entered.connect(_on_body_entered)
	area3D.body_exited.connect(_on_body_exited)
	timer.timeout.connect(_on_timer_timeout)
	_init_scanner_collision_level()
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
	area3D.monitorable = true
	area3D.monitoring = true

func _disable_scanner_area() -> void:
	area3D.monitorable = false
	area3D.monitoring = false

func _init_scanner_collision_level() -> void:
	area3D.set_collision_layer_value(scan_collision_level, true)
	area3D.set_collision_mask_value(scan_collision_level, true)
	area3D.set_collision_layer_value(1, false)
	area3D.set_collision_mask_value(1, false)
