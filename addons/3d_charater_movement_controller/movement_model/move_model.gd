extends Node
class_name MoveModel
@export var move_set : MoveSet
@export var character : CharacterBody3D
var camera_basis : Basis 
@export var inputCollector : MovementInputCollector = MovementInputCollector.new()
var facing_vector : Vector3 :
	get():
		facing_vector = -(character.basis.z)
		return facing_vector

func _ready():
	init_move_set()

func _physics_process(delta: float) -> void:
	var input = inputCollector.collect_inputs()
	move_set.update(input, delta)
	input.queue_free()

func init_move_set():
	#move_set.model = self
	move_set.accept_moves()

func pay_resource_cost(_move : Move):
	pass
	
func update_resources(_delta : float): # move to the character model script
	pass

func can_do_move(_move : Move) -> bool:
	return true
