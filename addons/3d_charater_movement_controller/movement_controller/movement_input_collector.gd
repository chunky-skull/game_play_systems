extends Node
class_name MovementInputCollector

func collect_inputs() -> MovementInputPackage:
	if Input.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	if Input.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var new_input := MovementInputPackage.new()
	
	# defaults to idle state
	new_input.actions.append("idle")

	new_input.direction = Input.get_vector("left", "right", "forward", "backward")
	if new_input.direction != Vector2.ZERO:
		new_input.actions.append("run")
		#if Input.is_action_pressed("sprint"):
			#new_input.actions.append("sprint")
		#if Input.is_action_just_pressed("dash"):
			#new_input.actions.append("dash")
			
	#if Input.is_action_just_pressed("jump"):
		#new_input.actions.append("jump")
		
	return new_input
	
