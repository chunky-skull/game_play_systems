extends Move
func default_lifecycle(input : MovementInputPackage):
	return top_affordable_input(input)

func on_enter_state():
	model.character.velocity = Vector3.ZERO
