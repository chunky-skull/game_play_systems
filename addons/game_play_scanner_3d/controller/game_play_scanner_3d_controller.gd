extends Node3D

@export var scan_input_label : String = "scan"
@export var scan_collision_level : int = 3
@export var scan_data_menu : Control
@export var scanner_area3D : Area3D
@export var scan_data_repo : Node

var target

signal scanned(scan_data)

func _ready() -> void:
	_init_scanner_collision_level()
	_connect_scanner()

func _connect_scanner() -> void:
	scanner_area3D.scanned.connect(scan_data_repo.on_scanned)

func _init_scanner_collision_level() -> void:
	scanner_area3D.init_scanner_collision_level(scan_collision_level)
