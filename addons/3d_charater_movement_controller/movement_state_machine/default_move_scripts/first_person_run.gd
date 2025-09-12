extends Move

@export var SPEED = 3.0
@export var TURN_SPEED = 2

func update(_input : MovementInputPackage, _delta : float):
	model.character.move_and_slide()
	
func default_lifecycle(input : MovementInputPackage):
	#if not model.character.is_on_floor():
		#return "midair" 
	
	return top_affordable_input(input)

func process_input_vector(input : MovementInputPackage, delta : float):
	var input_direction = ( model.character.basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
	var facing : Vector3 = model.facing_vector.normalized()
	var angle : float = facing.signed_angle_to(input_direction, Vector3.UP)
	var target : Vector3 = facing.rotated(Vector3.UP, angle) * SPEED

	model.character.velocity = model.character.velocity.move_toward(target, 20.0 * delta)
	
