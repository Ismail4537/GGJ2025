extends RigidBody2D

var player

func _ready() -> void:
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _process(delta: float) -> void:
	if get_parent().get_parent().get_name() == "Player" :
		player = get_parent().get_parent()
		if (player.isOnGround) :
			take_damage()

func take_damage():
	gravity_scale = 0
	set_collision_layer_value(4, false)
	$AnimatedSprite2D.play("Pop")

func _on_animation_finished() -> void:
	queue_free() 	

func _on_timer_timeout() -> void:
	take_damage()
