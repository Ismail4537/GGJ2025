extends StaticBody2D
var health = 3
var justMoved : bool = false

func _ready():
	$Sprite2D.scale = Vector2(0.05, 0.065)

func take_damage():
	if justMoved:
		return
	health -= 1
	if health < 1:
		$AnimationPlayer.play("Fall")
		justMoved = true
		# $CollisionShape2D.scale = Vector2(3, 24)
