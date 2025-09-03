extends Area3D

@export var interactive : Interactive
@export var trigger_area_size : Vector3

@export_category("Prompt")
@export var prompt_text : String
@export var prompt_position : Vector3

@onready var interact_input_collector: Node = $InteractInputCollector
@onready var prompt: Node3D = $Prompt
@onready var interaction_collision_shape: CollisionShape3D = $CollisionShape3D

var character_in_area : bool = false
var character : Node3D

func _ready() -> void:
	apply_trigger_area_size()
	prompt.init(prompt_text, prompt_position)
	
func _unhandled_input(_event: InputEvent) -> void:
	if interact_input_collector.pressed() and character_in_area:
		interactive.activate()

func _on_body_entered(body: Node3D) -> void:
	character_entered(body)
	prompt.show()

func _on_body_exited(body: Node3D) -> void:
	character_exited(body)
	prompt.hide()

func apply_trigger_area_size() -> void:
	interaction_collision_shape.shape.size = trigger_area_size

func character_entered(body: Node3D) -> void:
	character_in_area = true
	character = body

func character_exited(body: Node3D) -> void:
	character_in_area = false
