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
	var viewport_basis = model.camera_basis
	var input_direction = ( viewport_basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
	var facing : Vector3 = model.facing_vector
	var angle : float = facing.signed_angle_to(input_direction, Vector3.UP)
	var target : Vector3 = facing.rotated(Vector3.UP, angle) * SPEED
	if abs(angle) >= tracking_angular_speed * delta:
		var signed_angle : float = signf(angle)
		target = facing.rotated(Vector3.UP, signed_angle * tracking_angular_speed * delta) * TURN_SPEED
		angle = (signed_angle * tracking_angular_speed * delta)

	model.character.velocity = model.character.velocity.move_toward(target, 20.0 * delta)
	model.character.rotate_y(angle)
	
