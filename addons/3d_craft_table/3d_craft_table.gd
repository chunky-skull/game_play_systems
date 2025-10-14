class_name CraftingTable extends Node
@onready var crafting_menu: Control = $CraftingMenu

@export var recipe_repo: Array[CraftingRecipe] #an array of items the maker can make
	# each entry needs to have:
		# item ID
		# item reciepe = [item_a.id, item_a.id, item_b.id]
var selected #the item the player has selected from the craft item menu
# only needs the ID for game play items
# when the character activates a crafting table, their inventory is passed to the craft table
# or rather than directly interacting with the character's inventory, it emits signals for each action

signal remove_items(item_ids)
signal add_items(item_ids)

func _ready() -> void:
	var init_recipes = func() -> void:
		print_debug("init recipes")
	crafting_menu.init_recipe_list(recipe_repo)
	print_debug("ready")

func activate(on_remove_items: Callable, on_add_items: Callable) -> void:
	# opens the craft item menu
	# highlights items that the character has enough or the right raw materials to make
	# connect the character's inventory to all the appropriate signals
	remove_items.connect(on_remove_items)
	add_items.connect(on_add_items)

func deactivate(on_remove_items: Callable, on_add_items: Callable) -> void:
	# closes the craft item menu
	remove_items.disconnect(on_remove_items)
	add_items.disconnect(on_add_items)

func craft_selected_item() -> void:
	# adds selected item ID to the character's inventory
	_use_ingredients()
	emit_signal("add_items", [selected.id])

func add_recipe(recipe: CraftingRecipe) -> void:
	recipe_repo.append(recipe)

func break_down_item(item_id) -> void:
	# breaks down an item in the character's inventory into raw materials
	var reciepe = selected.reciepe
	emit_signal("add_items", reciepe)
	emit_signal("remove_items", [item_id])

func _use_ingredients() -> void:
	# removes selected item's raw material cost from character's inventory
	var reciepe = selected
	emit_signal("remove_items", reciepe)

func use_ingredients(item_repo: GamePlayItem3DLinkedList) -> void:
	# how to get an item repo linked list index?
	# how to get the selected recipe?
	# selected: CraftingRecipe
	var in_scope_variables: Dictionary = {
		"index" : 0
		}
	var index: int = 0
	var length: int = selected.ingredients.size()
	while index < length:
		var match_item: Callable = func(item)->bool:
			in_scope_variables.index += 1
			if item == selected.ingredients[index]:
				return true
			return false
		var rm_item: Callable = func(item)-> void:
			# how to remove the whole count?
			item_repo.remove(in_scope_variables.index)
		in_scope_variables.index = 0
		item_repo.iterate_to(match_item, rm_item)
		index += 1
	pass
