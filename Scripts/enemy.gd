extends CharacterBody2D


@export var speed = -60.0

var facing_right = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if (!$RayCast2D.is_colliding() && is_on_floor()) or is_on_wall():
		flip()

	velocity.x = speed
	move_and_slide()

func flip() -> void:
	facing_right = not facing_right
	
	# Flip the sprite.
	scale.x = abs(scale.x) * -1

	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1

