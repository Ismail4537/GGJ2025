extends CharacterBody2D


const RANGE = 500.0
var speed = 1500.0
var maxSpeed = 3000.0
var travel_dist = 0

func init(dir: int) -> void:
	if dir >= 0:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1


func _physics_process(delta: float) -> void:
	# Add the gravity.
	velocity.x += speed * delta
	velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)

	# travel_dist = velocity.x
	# if travel_dist > RANGE:
	# 	queue_free()

	move_and_slide()


func _on_bullet_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		print("Enemy hit")
		body.queue_free()
		self.queue_free()
