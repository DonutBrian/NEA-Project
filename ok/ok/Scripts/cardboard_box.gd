extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("A legendary solider was the last to use this")
	queue_free()
