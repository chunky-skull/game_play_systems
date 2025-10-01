extends Interactive

var crafting_table: CraftingTable = CraftingTable.new()

func _ready() -> void:
	var interactive = get_parent()
	interactive.body_exited.connect(_on_body_exited)
	interactive.activate.connect(_on_activate)

func _on_activate(character) -> void:
	crafting_table.activate(_on_remove_items(character), _on_add_items(character))

func _on_remove_items(character) -> Callable:
	var remove_items := func(items):
		var index = 0
		var length = items.length
		while index < length:
			character.inventory.remove_item(items[index])
			index += 1
	return remove_items

func _on_add_items(character) -> Callable:
	var remove_items := func(items):
		var index = 0
		var length = items.length
		while index < length:
			character.inventory.add_item(items[index])
			index += 1
	return remove_items

func _on_body_exited(character) -> void:
	crafting_table.deactivate(_on_add_items(character), _on_add_items(character))
