extends Interactive
@onready var crafting_table: CraftingTable = $"../CraftingTable"

func _ready() -> void:
	var interactive = get_parent()
	interactive.body_exited.connect(_on_body_exited)
	interactive.activate.connect(_on_activate)

func _on_activate(character) -> void:
	# refactor crafting_table.activate to only take character as an arguement
	crafting_table.toggle_activation(character.inventory)

func _on_body_exited(_character) -> void:
	crafting_table.deactivate()
