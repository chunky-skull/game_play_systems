extends Node

var item_repo #a linked list of items the maker can make
	# each entry needs to have:
		# item ID
		# item qauntity
		# item raw material cost or reciepe

# only needs the ID for game play items
# needs access to:
	# items available to make
	# character's inventory:
		# CRUD operations on raw materials there in
		# CRUD operations on items there in
# when the character activates a crafting table, their inventory is passed to the craft table

func activate() -> void:
	# opens the craft item menu
	# highlights items that the character has enough or the right raw materials to make
	pass

func deactivate() -> void:
	# closes the craft item menu
	pass
