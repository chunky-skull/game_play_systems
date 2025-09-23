extends Node3D

@export var toggle_menu_input_label : String = "journal"
@export var scan_input_label : String = "scan"
@export var scan_collision_level : int = 3
@export var scan_data_menu : Control
@export var scanner_area3D : Area3D
@export var scan_data_repo : Node

var target

signal scanned(scan_data)

func _ready() -> void:
	_init_scanner_collision_level()
	scanner_area3D.scanned.connect(scan_data_repo.on_scanned)
	close_scan_data_menu()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(toggle_menu_input_label):
		print_debug("journal press")
		toggle_scan_data_menu()

func _init_scanner_collision_level() -> void:
	scanner_area3D.init_scanner_collision_level(scan_collision_level)

func open_scan_data_menu() -> void:
	scan_data_menu.init_entry_list()
	scan_data_menu.visible = true

func close_scan_data_menu() -> void:
	scan_data_menu.visible = false

func toggle_scan_data_menu() -> void:
	var visiblity = scan_data_menu.visible
	if visiblity:
		close_scan_data_menu()
	else:
		open_scan_data_menu()
