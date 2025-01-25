extends Area2D

func _on_body_entered(body:Node2D) -> void:
	if body.get_parent().has_method("take_damage"):
		body.get_parent().take_damage()
	elif body.has_method("take_damage"):
		body.take_damage()
