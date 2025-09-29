extends Node

var item_repo #a linked list of items the maker can make
	# each entry needs to have:
		# item ID
		# item qauntity
		# item raw material cost or reciepe
var selected #the item the player has selected from the craft item menu
var craft_item_menu 

# only needs the ID for game play items
# needs access to:
	# items available to make
	# character's inventory:
		# CRUD operations on raw materials there in
		# CRUD operations on items there in
# when the character activates a crafting table, their inventory is passed to the craft table

signal add_item(item_id)

func activate() -> void:
	# opens the craft item menu
	# highlights items that the character has enough or the right raw materials to make
	pass

func deactivate() -> void:
	# closes the craft item menu
	pass
#func 
func craft_selected_item() -> void:
	# adds selected item ID to the character's inventory
	_use_ingredients()
	_add_to_inventory(selected.id)

func add_item_schema(schema) -> void:
	# adds an item ID to the item_repo
	pass

func break_down_item(item_id) -> void:
	# breaks down an item in the character's inventory into raw materials
	var raw_materials = _extract_ingredients(item_id)
	# adds the raw materials to character's inventory
	_add_to_inventory(raw_materials)
	pass

func _extract_ingredients(item):
	# gets the material cost for the item and returns the materials id and quanity as an array
	var raw_materials = []
	return raw_materials

func _use_ingredients() -> void:
	# removes selected item's raw material cost from character's inventory
	pass

func _add_to_inventory(item_ids) -> void:
	var index = 0
	var length = item_ids.size()
	
	while index < length:
		#character inventory.add_item(item_ids[index])
		#or emmit_sginal("add_item", item_id[0])
		index += 1
	pass
