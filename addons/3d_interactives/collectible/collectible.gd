extends Area3D
@export var point_value : int = 1

func _on_body_entered(body: Node3D) -> void:
	# the character runs into a collectible item and gains a the collectible's point value. The collectible does an exit animation 
	# and despawns
	queue_free()
