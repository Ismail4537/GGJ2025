extends StaticBody2D

func open():
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.play("Break")

# func take_damage():
# 	open()