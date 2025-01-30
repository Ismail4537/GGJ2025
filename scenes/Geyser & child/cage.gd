extends Node2D

var caged : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StaticBody2D.get_child(0).disabled = true
	$Area2D.get_child(0).disabled = false

func _on_area_2d_body_entered(body:Node2D) -> void:
	if caged == true: return
	if body.get_parent().has_method("take_damage"):
		body.get_parent().take_damage()
	elif body.has_method("take_damage"):
		body.take_damage()
	$StaticBody2D.get_child(0).set_deferred("disabled", false)
	$Area2D.get_child(0).set_deferred("disabled", true)
	caged = true
	print("Enemy Caged")
