extends Area2D

const SPEED = 500
const RANGE = 210
var travel_dist = 0
var dir = 1

func _physics_process(delta):
	if (dir == 0 or dir > 1 or dir < -1 ):
		dir = 1
	position.x += dir * SPEED * delta
	
	travel_dist += SPEED * delta
	if travel_dist > RANGE:
		queue_free()

func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
