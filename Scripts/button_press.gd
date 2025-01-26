extends Area2D

var pressed = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if pressed:
		print("Button held")

func _on_body_entered(body:Node2D) -> void:
	if pressed : return
	print(body)
	if body.is_in_group("Player") or body.is_in_group("Enemy"):
		pressed = true
		print("Button pressed")
