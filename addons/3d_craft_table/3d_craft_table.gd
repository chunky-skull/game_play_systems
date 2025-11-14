class_name CraftingTable extends Node
@onready var crafting_menu: Control = $CraftingMenu

@export var recipe_repo: Array[CraftingRecipe] #an array of items the maker can make
@export var character: Node3D
var selected_recipe: CraftingRecipe #the item the player has selected from the craft item menu


func _ready() -> void:
	crafting_menu.visible = false

func activate(inventory) -> void:
	if not is_active():
		crafting_menu.init_recipe_list(recipe_repo)
		set_each_item_enabled(inventory)
		crafting_menu.visible = true
		return
	return

func refresh_menu(inventory) -> void:
	clear_recipe_list()
	crafting_menu.init_recipe_list(recipe_repo)
	set_each_item_enabled(inventory)

func set_each_item_enabled(inventory) -> void:
	var index: int = 0
	var length: int = recipe_repo.size()
	
	while index < length:
		var recipe = recipe_repo[index]
		var in_scope_variables := {
			"enabled": false
		}
		
		var button_action: Callable = func()->void:
			add_item(recipe.output, inventory)
			use_ingredients(recipe.ingredients, inventory)
			refresh_menu(inventory)

		var is_item: Callable = func(slot):
			var ingredients_index: int = 0
			var ingredients_length: int = recipe.ingredients.size()
			while ingredients_index < ingredients_length:
				var ingredient = recipe.ingredients[ingredients_index]
				if slot.item == ingredient.item:
					if slot.count >= ingredient.amount:
						in_scope_variables.enabled = true
						break
					else:
						return true
				ingredients_index += 1
			return false
		
		inventory.item_repo.iterate_to(is_item)

		var recipe_ui = crafting_menu.recipe_list.get_child(index)
		crafting_menu.set_recipe_list_entry_button(recipe_ui, button_action, in_scope_variables.enabled)

		index += 1

func deactivate() -> void:
	clear_recipe_list()
	crafting_menu.visible = false

func is_active() -> bool:
	return crafting_menu.visible

func toggle_activation(inventory) -> void:
	if is_active():
		deactivate()
	else:
		activate(inventory)

func clear_recipe_list() -> void:
	for child in crafting_menu.recipe_list.get_children():
		crafting_menu.recipe_list.remove_child(child)
		child.queue_free()

func use_ingredients(ingredients, inventory) -> void:
	var index = 0
	var length = ingredients.size()
	while index < length:
		var ingredient = ingredients[index]
		print
		inventory.item_repo.remove_by_item(ingredient.item, ingredient.amount)
		index += 1

func add_item(item:GamePlayItem3D, inventory) -> void:
	inventory.item_repo.append_item(item)

func add_recipe(recipe: CraftingRecipe) -> void:
	recipe_repo.append(recipe)
