extends Control

@onready var recipe: VBoxContainer = $MarginContainer/RecipeList/Recipe
@onready var recipe_list: VBoxContainer = $MarginContainer/RecipeList

func _ready() -> void:
	recipe.visible = false

func init_recipe_list(recipe_repo) -> void:
	var length = recipe_repo.size()
	var index = 0
	while index < length:
		_init_recipe_list_entry(recipe_repo, index)
		index += 1
	
func _init_recipe_list_entry(recipe_repo, entry_index) -> void:
	var entry = recipe_repo[entry_index]
	var new_recipe = recipe.duplicate()
	recipe_list.add_child(new_recipe)
	_init_output_ingredient_list(entry, new_recipe)
	new_recipe.set_output_label(entry.output.label)
	new_recipe.visible = true

func init_recipe_list_entry(entry, is_enabled:bool) -> void:
	var new_recipe = recipe.duplicate()
	recipe_list.add_child(new_recipe)
	_init_output_ingredient_list(entry, new_recipe)
	new_recipe.set_output_label(entry.output.label)
	new_recipe.enable_craft_button(is_enabled)
	new_recipe.visible = true

func _init_output_ingredient_list(entry, new_recipe) -> void:
	var ingredients_length = entry.ingredients.size()
	var ingredient_index = 0
	while ingredient_index < ingredients_length:
		#var ingredient_text = _get_ingredient_text(entry, ingredient_index)
		var ingredient = entry.ingredients[ingredient_index]
		
		
		new_recipe.add_ingredient_list_entry(ingredient.item.label, ingredient.amount)
		ingredient_index += 1

func _get_ingredient_text(entry, index: int) -> String:
	var ingredient = entry.ingredients[index]
	var ingredient_text: String = str(ingredient.amount) + " " + ingredient.item.label
	return ingredient_text
