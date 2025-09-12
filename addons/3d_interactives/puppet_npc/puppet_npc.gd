extends Node3D

@export var interactive : Interactive
@export var trigger_area_size : Vector3

@export_category("Prompt")
#@export var prompt: Node3D
@export var prompt_text : String
@export var prompt_position : Vector3

@onready var interactive_area_3d: Area3D = $InteractiveArea3D
@onready var text_3d: Node3D = $Text3D

func _ready() -> void:
	init_interactive_area_3d()
	var text : String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
	text_3d.apply_prompt_text(text)

func init_interactive_area_3d() -> void:
	interactive_area_3d.interactive = interactive
	interactive_area_3d.trigger_area_size = trigger_area_size
	interactive_area_3d.prompt_text = prompt_text
	interactive_area_3d.prompt_position = prompt_position
