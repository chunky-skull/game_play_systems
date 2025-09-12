extends Node3D
@onready var rich_text_label: RichTextLabel = $TextTexture/RichTextLabel

func init(prompt_text:String, new_position : Vector3 ) -> void:
	hide()
	apply_prompt_text(prompt_text)
	position = new_position 

	
func hide() -> void:
	visible = false
	
func show()-> void:
	visible = true

func apply_prompt_text(text: String) -> void:
	print_debug(rich_text_label,is_node_ready())
	rich_text_label.text = text
	
