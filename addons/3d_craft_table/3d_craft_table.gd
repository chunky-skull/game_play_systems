class_name CraftingTable extends Node
@onready var crafting_menu: Control = $CraftingMenu

@export var recipe_repo: Array[CraftingRecipe] #an array of items the maker can make
var selected_recipe: CraftingRecipe #the item the player has selected from the craft item menu

signal remove_items(ingredients)
signal add_items(ingredients)

func _ready() -> void:
	var init_recipes = func() -> void:
		print_debug("init recipes")
	crafting_menu.init_recipe_list(recipe_repo)
	print_debug("ready")

func activate(on_remove_items: Callable, on_add_items: Callable, inventory) -> void:
	# opens the craft item menu
	# highlights items that the character has enough or the right raw materials to make
	set_each_item_enabled(inventory)
	# connect the character's inventory to all the appropriate signals
	remove_items.connect(on_remove_items)
	add_items.connect(on_add_items)

func set_each_item_enabled(inventory) -> void:
	var index: int = 0
	var length: int = recipe_repo.size()
	
	while index < length:
		var recipe = recipe_repo[index]
		var ingredients_index: int = 0
		var ingredients_length: int = recipe.ingredients.size()
		var enabled: bool = false
		
		while ingredients_index < ingredients_length:
			var ingredient = recipe.ingredients[ingredients_index]
			var is_target_item: Callable = func(slot):
				return slot.item == ingredient.item
			var set_enabled: Callable = func(slot):
				if slot.count >= ingredient.amount:
					enabled = true
			inventory.item_repo.iterate_to(is_target_item, set_enabled)
			if not enabled:
				break
			ingredients_index += 1
			
		crafting_menu.init_recipe_list_entry(recipe, enabled) 
		index += 1

func deactivate(on_remove_items: Callable, on_add_items: Callable) -> void:
	# closes the craft item menu
	remove_items.disconnect(on_remove_items)
	add_items.disconnect(on_add_items)

func craft_selected_item() -> void:
	# adds selected item ID to the character's inventory
	_use_ingredients()
	emit_signal("add_items", [selected_recipe.output])

func add_recipe(recipe: CraftingRecipe) -> void:
	recipe_repo.append(recipe)

func _use_ingredients() -> void:
	# removes selected item's raw material cost from character's inventory
	var ingredients = selected_recipe.ingredients
	emit_signal("remove_items", ingredients)

func use_ingredients(item_repo: GamePlayItem3DLinkedList) -> void:
	var index: int = 0
	var length: int = selected_recipe.ingredients.size()
	while index < length:
		var ingredient:CraftingIngredient = selected_recipe.ingredients[index]
		item_repo.remove_by_item(ingredient.item, ingredient.amount)
		index += 1
