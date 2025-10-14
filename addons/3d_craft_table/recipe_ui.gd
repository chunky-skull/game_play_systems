extends VBoxContainer

@onready var output_image: TextureRect = $OutputContainer/OutputImage
@onready var ingredient: HBoxContainer = $IngredientList/Ingredient
@onready var output_label: Label = $OutputContainer/OutputLabel
@onready var ingredient_list: HBoxContainer = $IngredientList

func _ready() -> void:
	ingredient.visible = false

func set_output_label(new_label: String) -> void:
	output_label.text = new_label
	
func add_ingredient_list_entry(label: String, amount: int) -> void:
	var new_ingredient = ingredient.duplicate()
	ingredient_list.add_child(new_ingredient)
	new_ingredient.get_child(0).text = str(amount)
	new_ingredient.get_child(1).text = label
	new_ingredient.visible = true
