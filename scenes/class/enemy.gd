extends CharacterBody2D


@export var speed = 1000.0
@export var maxSpeed = 2000.0
@export var damage = 1

var facing_right = false
var ded : bool = false

func _ready():
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta: float) -> void:
	if ded == false:
		gravity(delta)
		movement(delta)
	flip()
	move_and_slide()

func gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func movement(delta):
	# Set the velocity.
	velocity.x += speed * delta
	velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)

func flip():
	if !$RayCast2D.is_colliding() && is_on_floor():
		facing_right = !facing_right
		scale.x = abs(scale.x) * -1
		
		if facing_right:
			speed = abs(speed)
			velocity.x = speed
		else:
			speed = abs(speed) * -1
			velocity.x = speed

func take_damage():
	velocity = Vector2(0, 0)
	ded = true
	$CollisionShape2D.set_deferred("disabled", true)
	$HurtBox/CollisionShape2D.set_deferred("disabled", true)
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.play("Die")

func _on_animation_finished():
	if $AnimatedSprite2D.animation == "Die":
		$AnimatedSprite2D/AnimationPlayer.play("Flash")
		await get_tree().create_timer(1.0).timeout
		queue_free()

func _on_hit_box_area_entered(area:Area2D) -> void:
	if area.name == "HurtBox":
		if area.get_parent().is_in_group("bubble"):
			area.get_parent().take_damage()
