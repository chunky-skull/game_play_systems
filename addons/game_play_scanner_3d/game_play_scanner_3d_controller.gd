extends Node3D

@export var scan_collision_level : int = 3
@export var scan_input_label : String
@export var area3D : Area3D
@export var timer : Timer

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
	timer.wait_time = body.scan_time
	timer.start()
	
func _on_body_exited(body) -> void:
	timer.stop()

func _on_timer_timeout() -> void:
	print_debug("scanned")

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
