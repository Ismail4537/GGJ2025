extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("cutscene1")
	$CutsceneAudio.play()
	$Page5/cut5_1.self_modulate = Color(1, 1, 1, 0)
	$Page5/cut5_2.self_modulate = Color(1, 1, 1, 0)
	$Page4/cut4_1.self_modulate = Color(1, 1, 1, 0)
	$Page4/cut4_2.self_modulate = Color(1, 1, 1, 0)
	$Page4/cut4_3.self_modulate = Color(1, 1, 1, 0)
	$Page4/cut4_5.self_modulate = Color(1, 1, 1, 0)
	$Page4/cut4_6.self_modulate = Color(1, 1, 1, 0)

func _process(delta: float) -> void:
	skip_cutscene()

func skip_cutscene() -> void:
	if Input.is_action_just_pressed("esc"):
		$ChangePage.play()
		get_tree().change_scene_to_file("res://scenes/Levels/game_test.tscn")

func call_cutscene2() -> void:
	print("cutscene2")
	$ChangePage.play()
	$AnimationPlayer.play("cutscene2")

func call_cutscene3() -> void:
	print("cutscene3")
	$ChangePage.play()
	$AnimationPlayer.play("cutscene3")

func call_cutscene4() -> void:
	print("cutscene4")
	$ChangePage.play()
	$AnimationPlayer.play("cutscene4")

func call_cutscene5() -> void:
	print("cutscene5")
	$ChangePage.play()
	$AnimationPlayer.play("cutscene5")

func call_finish() -> void:
	print("finish")
	$ContinueButton.show()
	$ContinueButton.grab_focus()
