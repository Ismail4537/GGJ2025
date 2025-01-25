extends RigidBody2D

@onready var bubbleTimer := $Timer as Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bubbleTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	queue_free()
