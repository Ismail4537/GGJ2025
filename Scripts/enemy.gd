extends CharacterBody2D


@export var speed = -1000.0
@export var maxSpeed = 2000.0

var facing_right = false

func _ready() -> void:
	# Set the animation
	$AnimatedSprite2D.play("walking")
	$AnimatedSprite2D.flip_h = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Set the velocity.
	velocity.x += speed * delta
	velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)

	if !$RayCast2D.is_colliding() && is_on_floor():
		facing_right = !facing_right
		scale.x = abs(scale.x) * -1
		
		if facing_right:
			speed = abs(speed)
			velocity.x = speed
		else:
			speed = abs(speed) * -1
			velocity.x = speed

	move_and_slide()


<<<<<<< HEAD
=======
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
>>>>>>> eb030d69aa2b76e53cb75acadb9c4bf1f06f8335
