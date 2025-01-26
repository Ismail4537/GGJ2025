extends Area2D

const SPEED = 600
const RANGE = 1000
var travel_dist = 0
var dir = 1

func _physics_process(delta):
	if (dir == 0 or dir > 1 or dir < -1 ):
		dir = 1
	if dir >= 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true
	position.x += dir * SPEED * delta
	
	travel_dist += SPEED * delta
	if travel_dist > RANGE:
		queue_free()

func setDir(new_dir):
	dir = new_dir

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
	queue_free()
