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

func _on_hit_box_area_entered(area:Area2D) -> void:
	if area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage()
	elif area.has_method("take_damage"):
		area.take_damage()

func take_damage():
	queue_free()

func _on_hit_box_body_entered(body:Node2D) -> void:
	if body.get_parent().has_method("take_damage"):
		body.get_parent().take_damage()
	elif body.has_method("take_damage"):
		body.take_damage()
