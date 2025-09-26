extends Node

var shopping_cart #an array or linked list of items the player has selected to buy
var item_repo #a linked list of items the maker can make
	# each entry needs to have:
		# item ID
		# item qauntity
		# item raw material cost or reciepe

# rename this plugin to "3D Item Maker"
# only needs the ID for game play items
# needs access to:
	# items available to make
	# character's inventory:
		# CRUD operations on raw materials there in
		# CRUD operations on items there in

func buy() -> void:
	pass

func sell() -> void:
	pass

func add_to_cart(item) -> void:
	pass

func remove_from_cart(item) -> void:
	pass

func empty_cart(item)-> void:
	pass
