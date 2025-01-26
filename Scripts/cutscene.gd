extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("cutscene1")
	$Page5/cut5_1.self_modulate = Color(1, 1, 1, 0)
	$Page5/cut5_2.self_modulate = Color(1, 1, 1, 0)
	$Page4/cut4_1.self_modulate = Color(1, 1, 1, 0)
	$Page4/cut4_2.self_modulate = Color(1, 1, 1, 0)
	$Page4/cut4_3.self_modulate = Color(1, 1, 1, 0)
	$Page4/cut4_5.self_modulate = Color(1, 1, 1, 0)
	$Page4/cut4_6.self_modulate = Color(1, 1, 1, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func call_cutscene2() -> void:
	print("cutscene2")
	$AnimationPlayer.play("cutscene2")

func call_cutscene3() -> void:
	print("cutscene3")
	$AnimationPlayer.play("cutscene3")

func call_cutscene4() -> void:
	print("cutscene4")
	$AnimationPlayer.play("cutscene4")

func call_cutscene5() -> void:
	print("cutscene5")
	$AnimationPlayer.play("cutscene5")

func call_finish() -> void:
	print("finish")
	$ContinueButton.show()
	$ContinueButton.grab_focus()