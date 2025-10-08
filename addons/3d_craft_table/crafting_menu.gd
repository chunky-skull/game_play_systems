extends Control

@onready var recipe: VBoxContainer = $MarginContainer/RecipeList/Recipe
@onready var recipe_list: HBoxContainer = $MarginContainer/RecipeList

func _ready() -> void:
	recipe.visible = false

func init_recipe_list(recipe_repo) -> void:
	var length = recipe_repo.size()
	var index = 0
	while index < length:
		var new_recipe = recipe.duplicate()
		recipe_list.add_child(new_recipe)
		var label = new_recipe.get_child(0).get_child(0)
		var ingredient_list: ItemList = new_recipe.get_child(1)
		var entry = recipe_repo[index]
		var entry_length = entry.ingredients.size()
		var entry_index = 0
		while entry_index < entry_length:
			var ingredient = entry.ingredients[entry_index]
			var ingredient_text: String = str(ingredient.amount) + " " +ingredient.item.label 
			ingredient_list.add_item(ingredient_text)
			entry_index += 1
			
		label.text = entry.output.label
		new_recipe.visible = true
		index += 1
