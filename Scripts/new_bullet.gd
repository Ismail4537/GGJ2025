extends CharacterBody2D


const RANGE = 500.0
var speed = 3000.0
var maxSpeed = 10000.0
var travel_dist = 0

func init(dir: int) -> void:
	if dir >= 0:
		speed = abs(speed)
		$Sprite2D.flip_h = false
	else:
		speed = abs(speed) * -1
		$Sprite2D.flip_h = true


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
		if body.has_method("take_damage"):
			body.take_damage()
		self.queue_free()
