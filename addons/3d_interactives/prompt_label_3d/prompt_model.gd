extends Node3D
@onready var prompt_label: Label = $PromptTexture/Label

func init(prompt_text:String, new_position : Vector3 ) -> void:
	hide()
	apply_prompt_text(prompt_text)
	position = new_position 

	
func hide() -> void:
	visible = false
	
func show()-> void:
	visible = true

func apply_prompt_text(text: String) -> void:
	prompt_label.text = text
	
