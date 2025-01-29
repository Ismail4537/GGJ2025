extends Area2D

const SPEED = 600
const RANGE = 1000
var travel_dist = 0
var dir = 1
var popped : bool = false

func _ready():
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta):
	if (dir == 0 or dir > 1 or dir < -1 ):
		dir = 1
	if dir >= 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	travel_dist += SPEED * delta
	if travel_dist > RANGE:
		pop()
	if popped == false:
		movement(delta)

func movement(delta):
	position.x += dir * SPEED * delta

func setDir(new_dir):
	dir = new_dir

func pop():
	$CollisionShape2D.set_deferred("disabled", true)
	popped = true
	$AnimatedSprite2D.play("Pop")

func _on_animation_finished():
	if $AnimatedSprite2D.animation == "Pop":
		queue_free()

func _on_body_entered(body):
	pop()
	if body.has_method("take_damage"):
		body.take_damage()
