extends Area3D

@export var interactive : Interactive
@export var trigger_area_size : Vector3

@export_category("Prompt")
@export var prompt: Label3D
@export var prompt_text : String
@export var prompt_position : Vector3

@onready var interact_input_collector: InteractInputCollector = InteractInputCollector.new()
@onready var interaction_collision_shape: CollisionShape3D = $CollisionShape3D

var character_in_area : bool = false
var character : Node3D

func _ready() -> void:
	apply_trigger_area_size()
	prompt.position = prompt_position 
	prompt.text = prompt_text
	prompt.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _unhandled_input(_event: InputEvent) -> void:
	if interact_input_collector.pressed() and character_in_area:
		interactive.activate()

func _on_body_entered(body: Node3D) -> void:
	character_entered(body)
	prompt.visible = true
	print_debug("body entered")

func _on_body_exited(body: Node3D) -> void:
	character_exited(body)
	prompt.visible = false

func apply_trigger_area_size() -> void:
	interaction_collision_shape.shape.size = trigger_area_size

func character_entered(body: Node3D) -> void:
	character_in_area = true

func character_exited(body: Node3D) -> void:
	character_in_area = false
