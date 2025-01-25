extends Node2D

var trigger_ammount = 0
var trigger_ammount_true = 0
var opened : bool = false

func _ready():
	for child in get_children():
		if child.is_in_group("cage") or child.is_in_group("button_press") or child.is_in_group("button_held"):
			trigger_ammount += 1
	print(trigger_ammount)

func _process(delta: float) -> void:
	if opened == true:
		return
	if trigger_ammount_true == trigger_ammount:
		open_geyser()
		opened = true
	trigger_ammount_true = 0
	for child in get_children():
		if child.is_in_group("cage"):
			if child.caged == true:
				trigger_ammount_true += 1
		if child.is_in_group("button_press"):
			if child.pressed == true:
				trigger_ammount_true += 1
		if child.is_in_group("button_held"):
			if child.pressed == false:
				trigger_ammount_true += 1

func open_geyser():
	if get_parent().is_in_group("geyser"):
		get_parent().open()