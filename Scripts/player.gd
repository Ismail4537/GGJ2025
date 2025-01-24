extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var isFacing
var bubble = 5
@onready var bubbleTimer := $Timer as Timer

func _physics_process(delta: float) -> void:
	Gravity(delta)
	Movement()
	if (Input.is_action_just_pressed("addBubble") and is_on_floor() and !is_on_ceiling() and bubble > 0):
		makeBubble()
		bubble -= 1
	if (Input.is_action_just_pressed("shootBubble")):
		shoot()

func Movement():
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if (direction > 0 or direction < 0):
			isFacing = direction
			if (isFacing > 0):
				$Sprite2D.flip_h = false
				%Muzzle.position.x = 64
			else:
				$Sprite2D.flip_h = true
				%Muzzle.position.x = -64
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func makeBubble():
	self.global_position.y -= 50
	bubbleTimer.start()

func Gravity(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta

func _on_timer_timeout() -> void:
	const BUBBLE = preload("res://Scene/Bubble.tscn")
	if (BUBBLE != null):
		var new_bubble = BUBBLE.instantiate()
		new_bubble.position.x = %SpBubble.global_position.x
		new_bubble.position.y = %SpBubble.global_position.y + 50
		new_bubble.rotation = %SpBubble.global_rotation
		%SpBubble.add_child(new_bubble)

func shoot():
	const BULLET = preload("res://Scene/Bullet.tscn")
	if (BULLET != null):
		var dir : float = -1 if $Sprite2D.flip_h == true else 1
		var new_bullet = BULLET.instantiate()
		new_bullet.dir = dir
		new_bullet.global_position = %Muzzle.global_position
		new_bullet.global_rotation = %Muzzle.global_rotation
		%Muzzle.add_child(new_bullet)
		print("pew")