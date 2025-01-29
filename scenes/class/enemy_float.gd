extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var hit = false

func _physics_process(delta: float) -> void:
	if not is_on_floor() and hit:
		velocity += get_gravity() * delta
	if is_on_floor():
		const ENEMY = preload("res://scenes/class/enemy.tscn")
		if (ENEMY != null):
			var new_enemy = ENEMY.instantiate()
			new_enemy.position = global_position
			new_enemy.rotation = global_rotation
			get_parent().add_child(new_enemy)
			queue_free()
	move_and_slide()

func take_damage():
	hit = true

func _on_hit_box_body_entered(body:Node2D) -> void:
	if body.get_parent().has_method("take_damage"):
		body.get_parent().take_damage()
	elif body.has_method("take_damage"):
		body.take_damage()
