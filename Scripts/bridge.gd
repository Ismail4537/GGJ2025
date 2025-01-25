extends StaticBody2D
var health = 3
var justMoved : bool = false
func take_damage():
	if justMoved:
		return
	health -= 1
	if health < 1:
		$AnimationPlayer.play("Fall")
		justMoved = true
		# $CollisionShape2D.scale = Vector2(3, 24)
