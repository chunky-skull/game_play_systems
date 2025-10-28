class_name CraftingTable extends Node
@onready var crafting_menu: Control = $CraftingMenu

@export var recipe_repo: Array[CraftingRecipe] #an array of items the maker can make
@export var character: Node3D
var selected_recipe: CraftingRecipe #the item the player has selected from the craft item menu


func _ready() -> void:
	crafting_menu.visible = false

func activate(inventory) -> void:
	# opens the craft item menu
	# highlights items that the character has enough or the right raw materials to make
	clear_recipe_list()
	crafting_menu.init_recipe_list(recipe_repo)
	print_debug(inventory)
	set_each_item_enabled(inventory)
	# connect the character's inventory to all the appropriate signals
	crafting_menu.visible = true

func refresh_menu(inventory) -> void:
	set_each_item_enabled(inventory)

func set_each_item_enabled(inventory) -> void:
	var index: int = 0
	var length: int = recipe_repo.size()
	
	while index < length:
		var recipe = recipe_repo[index]
		var ingredients_index: int = 0
		var ingredients_length: int = recipe.ingredients.size()
		var in_scope_variables := {
			"enabled": false
		}
		
		var button_action: Callable = func()->void:
			add_item(recipe.output, inventory)
			use_ingredients(recipe.ingredients, inventory)
			refresh_menu(inventory)
			
		while ingredients_index < ingredients_length:
			var ingredient = recipe.ingredients[ingredients_index]
			var is_target_item: Callable = func(slot):
				return slot.item == ingredient.item
			var set_enabled: Callable = func(slot):
				if slot.count >= ingredient.amount:
					in_scope_variables.enabled = true
			inventory.item_repo.iterate_to(is_target_item, set_enabled)
			if not in_scope_variables.enabled:
				break
			ingredients_index += 1
			
		var recipe_ui = crafting_menu.recipe_list.get_child(index)
		crafting_menu.set_recipe_list_entry_button(recipe_ui, button_action, in_scope_variables.enabled)

		index += 1

func deactivate() -> void:
	crafting_menu.visible = false

func clear_recipe_list() -> void:
	for child in crafting_menu.recipe_list.get_children():
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
