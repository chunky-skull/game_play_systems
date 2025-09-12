extends Interactive
@export var collectible: Node3D 

func activate() -> void:
	collectible.visible = not collectible.visible
