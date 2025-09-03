extends Interactive
@onready var collectible: Node3D = $"../../Collectible"

func activate() -> void:
	collectible.visible = not collectible.visible
