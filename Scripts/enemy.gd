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

func take_damage():
	queue_free()