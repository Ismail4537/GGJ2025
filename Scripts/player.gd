extends CharacterBody2D

@export var speed = 0
@export var maxSpeed = 0
@export var friction = 0.05
@export var gravity = 2500.0

var isFacing
var bubble = 8
var bubbleCount = 0
var isOnGround : bool
var thereIsCeiling : bool = false
var isReady : bool = true
var invicible : bool = false
var knocked : bool = false
var itCameFrom

@onready var bubbleTimer := $Timer as Timer
@onready var invicibilityCooldown := $CDInvicibility as Timer
@onready var shootCooldown := $CDShoot as Timer
@onready var detectBubble := $DetectBubble as RayCast2D
@onready var detectCeiling := $DetectCeiling as RayCast2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	KeyInputs()
	if is_on_floor():
		knocked = false
	var colide = detectBubble.get_collider()
	if colide != null :
		if is_on_floor() and colide.is_in_group("ground"):
			isOnGround = true
			bubbleCount = 0
		else :
			isOnGround = false
	var ceiling = detectCeiling.get_collider()
	if ceiling != null :
		if ceiling.is_in_group("ground"):
			thereIsCeiling = true
	else :
		thereIsCeiling = false
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if !knocked:
		if direction:
			velocity.x += direction * speed * delta
			velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)

			if direction != 0:
				isFacing = direction
				if isFacing > 0:
					$AnimatedSprite2D.flip_h = false
					$AnimatedSprite2D.play("walking")
					%Muzzle.position.x = 64
				else:
					$AnimatedSprite2D.flip_h = true
					$AnimatedSprite2D.play("walking")
					%Muzzle.position.x = -64
		else:
			velocity.x = move_toward(velocity.x, 0, speed * delta)
			$AnimatedSprite2D.play("idle")

		move_and_slide()


func KeyInputs():
	# Movement(delta)
	if (Input.is_action_just_pressed("addBubble") and is_on_floor() and !thereIsCeiling and bubbleCount < 6):
		makeBubble()
	if Input.is_action_just_pressed("shootBubble"):
		shoot()

func makeBubble():
	global_position.y -= 50
	bubbleTimer.start()


func _on_timer_timeout() -> void:
	const BUBBLE = preload("res://scenes/Bubble.tscn") # Ensure this path is correct and the file exists
	if (BUBBLE != null):
		var new_bubble = BUBBLE.instantiate()
		new_bubble.position.x = %SpBubble.global_position.x
		new_bubble.position.y = %SpBubble.global_position.y + 50
		new_bubble.rotation = %SpBubble.global_rotation
		isOnGround = false
		%SpBubble.add_child(new_bubble)
		bubbleCount += 1

func shoot():
	print("shoot")
	if isReady :
		isReady = false
		const BULLET = preload("res://scenes/new_Bullet.tscn")
		if (BULLET != null):
			var dir : float = -1 if $AnimatedSprite2D.flip_h == true else 1
			var new_bullet = BULLET.instantiate()
			new_bullet.init(dir)
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
