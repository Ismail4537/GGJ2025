extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var isFacing
var bubble = 8
var bubbleCount = 0
var isOnGround : bool
var isReady : bool = true
var invicible : bool = false
var knocked : bool = false
var itCameFrom

@onready var bubbleTimer := $Timer as Timer
@onready var invicibilityCooldown := $CDInvicibility as Timer
@onready var shootCooldown := $CDShoot as Timer
@onready var detectBubble := $DetectBubble as RayCast2D
var colide : Node2D

func _physics_process(delta: float) -> void:
	Gravity(delta)
	KeyInputs()
	if is_on_floor():
		knocked = false
	colide = detectBubble.get_collider()
	if colide != null :
		if is_on_floor() and colide.is_in_group("ground"):
			isOnGround = true
			bubbleCount = 0
		else :
			isOnGround = false
	print(str(is_on_floor()) +" "+ str(isOnGround))
	
func KeyInputs():
	Movement()
	if (Input.is_action_just_pressed("addBubble") and is_on_floor() and !is_on_ceiling() and bubbleCount < 6):
		makeBubble()
	if Input.is_action_just_pressed("shootBubble"):
		shoot()

func Movement():
	var direction := Input.get_axis("ui_left", "ui_right")
	if !knocked:
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
	global_position.y -= 50
	bubbleTimer.start()

func Gravity(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta

func _on_timer_timeout() -> void:
	const BUBBLE = preload("res://scenes/Bubble.tscn")
	if (BUBBLE != null):
		var new_bubble = BUBBLE.instantiate()
		new_bubble.position.x = %SpBubble.global_position.x
		new_bubble.position.y = %SpBubble.global_position.y + 50
		new_bubble.rotation = %SpBubble.global_rotation
		isOnGround = false
		%SpBubble.add_child(new_bubble)
		bubbleCount += 1

func shoot():
	if isReady :
		isReady = false
		const BULLET = preload("res://scenes/Bullet.tscn")
		if (BULLET != null):
			var dir : float = -1 if $Sprite2D.flip_h == true else 1
			var new_bullet = BULLET.instantiate()
			new_bullet.dir = dir
			new_bullet.global_position = %Muzzle.global_position
			new_bullet.global_rotation = %Muzzle.global_rotation
			%Muzzle.add_child(new_bullet)
		shootCooldown.start()

func addBuble():
	bubble += 3

func player_take_damage(dir : int):
	if !invicible or !knocked:
		bubble -= 1
		velocity.x = dir * 500
		velocity.y = -100
		knocked = true
		# invicible = true
		# invicibilityCooldown.start()

func _on_cd_shoot_timeout() -> void:
	isReady = true

func _on_cd_invicibility_timeout() -> void:
	invicible = false

func _on_hit_box_right_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		itCameFrom = -1
		player_take_damage(itCameFrom)

func _on_hit_box_left_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		itCameFrom = 1
		player_take_damage(itCameFrom)

func _on_hit_box_right_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		itCameFrom = -1
		player_take_damage(itCameFrom)


func _on_hit_box_left_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		itCameFrom = 1
		player_take_damage(itCameFrom)