extends RigidBody2D

var player

func _process(delta: float) -> void:
	if get_parent().get_parent().get_name() == "Player" :
		player = get_parent().get_parent()
		if (player.isOnGround) :
			queue_free()

func take_damage():
	queue_free()