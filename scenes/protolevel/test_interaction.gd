extends Interactive
@export var collectible: Node3D 

func _ready() -> void:
	get_parent().activate.connect(_on_activate)
	
func _on_activate(_character) -> void:
	collectible.visible = not collectible.visible
