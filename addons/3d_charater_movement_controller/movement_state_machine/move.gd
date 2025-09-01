extends Node
class_name Move

@export var label : String
@export var animation : String
@export var db_label : String #need to come up with a better name
@export var priority : int
@export var tracks_vector : bool = false
@export var tracking_angular_speed : float = 10 #need to come up with a better name
@export var cost : float = 0
@export var resource_type : String = "stamina"

var enter_state_time : float
var model : MoveModel
var move_set : MoveSet
var DURATION : float
var initial_position : Vector3

func _update(input : MovementInputPackage, delta : float):
	if tracks_input_vector():
		process_input_vector(input, delta)
	update(input, delta)

func update(_input : MovementInputPackage, _delta : float):
	pass
	
func process_input_vector(input : MovementInputPackage, delta : float):
	var viewport_basis = model.camera_basis
	var input_direction = ( viewport_basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
	var facing = model.facing_vector
	var angle = facing.signed_angle_to(input_direction, Vector3.UP)
	model.character.rotate_y(clamp(angle, -tracking_angular_speed * delta, tracking_angular_speed * delta) * delta)

func check_relevance(input : MovementInputPackage) -> String:
	return default_lifecycle(input)

func _on_exit_state():
	on_exit_state()

func on_exit_state():
	pass

func _on_enter_state():
	initial_position = model.character.global_position
	pay_resource_cost()
	mark_enter_state()
	on_enter_state()

func mark_enter_state():
	enter_state_time = Time.get_unix_time_from_system()
	
func pay_resource_cost():
	model.pay_resource_cost(self)

func on_enter_state():
	pass

func default_lifecycle(input : MovementInputPackage):
	if works_longer_than(DURATION):
		return top_affordable_input(input)
	return "okay"

func get_progress() -> float:
	var now = Time.get_unix_time_from_system()
	return now - enter_state_time

func works_longer_than(time : float) -> bool:
	if get_progress() >= time:
		return true
	return false

func update_resources(delta : float): # move to the character model script
	model.update_resources(delta)

func top_affordable_input(input : MovementInputPackage) -> String:
	input.actions.sort_custom(move_set.moves_priority_sort)
	var move : Move
	for action in input.actions:
		move = move_set.move[action]
		if model.can_do_move(move):
			if move == self:
				return "okay"
			else:
				return action
	return "throwing because for some reason input.actions doesn't contain even idle" 
	
func tracks_input_vector():
	return tracks_vector

func overwrite_move(input: MovementInputPackage):
	var move = top_affordable_input(input)
	if move != "okay" and move_set.moves_priority_sort(move, label):
		return move
	return "okay"

#func get_root_position_delta(delta_time : float) -> Vector3:
	#return move_set.moves_repo.get_root_delta_pos(db_label, get_progress(), delta_time)
