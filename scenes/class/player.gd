extends CharacterBody2D

@export var speed = 100
@export var maxSpeed = 1000
@export var friction = 0.05

var isFacing
var bubble = 3
var bubbleCount = 0
var isOnGround : bool
var thereIsCeiling : bool = false
var isReady : bool = true
var invicible : bool = false
var knocked : bool = false
var ded : bool = false
var shooting
var damage

@onready var bubbleTimer := $Timer as Timer
@onready var detectBubble := $DetectBubble as RayCast2D
@onready var detectCeiling := $DetectCeiling as RayCast2D

func _ready():
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta: float) -> void:
	gravity(delta)
	if !ded:
		Move(delta)
		KeyInputs()
		loop_animation_controller()
	getGround_n_Ceiling()
	move_and_slide()

func gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func getGround_n_Ceiling():
	if knocked and is_on_floor():
		velocity.x = 0
	var colide = detectBubble.get_collider()
	if colide != null :
		if is_on_floor():
			if colide.is_in_group("ground"):
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

func KeyInputs():
	# Movement(delta)
	if (Input.is_action_just_pressed("addBubble") and is_on_floor() and !thereIsCeiling and !shooting and bubbleCount < 6):
		makeBubble()
	if Input.is_action_just_pressed("shootBubble") and is_on_floor():
		shoot()

func makeBubble():
	global_position.y -= 50
	bubbleTimer.start()

func Move(delta):
	if !knocked and !shooting:
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
				velocity.x += direction * speed * delta
				velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)
				flip(direction)
		else:
			velocity.x = move_toward(velocity.x, 0, speed * delta)

func loop_animation_controller():
	if is_on_floor():
		if !knocked and !shooting:
			if abs(velocity.x) > 0.01:
				$AnimatedSprite2D.play("walking")
			else:
				$AnimatedSprite2D.play("idle")

func flip(direction):
	if direction != 0:
		isFacing = direction
		if isFacing > 0:
			$AnimatedSprite2D.flip_h = false
			%Muzzle.position.x = 64
		else:
			$AnimatedSprite2D.flip_h = true
			%Muzzle.position.x = -64

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
	if isReady :
		velocity.x = 0
		shooting = true
		$AnimatedSprite2D.play("Shoot")
		isReady = false
		await get_tree().create_timer(0.5).timeout
		const BULLET = preload("res://scenes/bullet.tscn")
		if (BULLET != null):
			var dir : float = -1 if $AnimatedSprite2D.flip_h == true else 1
			var new_bullet = BULLET.instantiate()
			new_bullet.position = %Muzzle.global_position
			new_bullet.rotation = %Muzzle.global_rotation
			new_bullet.setDir(dir)
			%Muzzle.add_child(new_bullet)

func addBuble():
	bubble += 3

func player_take_damage(dir : int, damage : int):
	if !knocked:
		bubble -= damage
		velocity.x = dir * 750
		velocity.y = -300
		flip(-dir)
		await get_tree().create_timer(0.05).timeout
		knocked = true
		$AnimatedSprite2D.play("Hit")
		$AnimatedSprite2D/AnimationPlayer.play("Hit")
		await get_tree().create_timer(1).timeout
		knocked = false
		if bubble >= 1:
			$AnimatedSprite2D/AnimationPlayer.play("idle")
		else:
			ded = true
			print ("Game Over")
			$AnimatedSprite2D/AnimationPlayer.play("idle")
			$AnimatedSprite2D.play("Die")

func _on_hit_box_right_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy") and area.is_in_group("HitBox"):
		var itCameFrom = -1
		damage = area.get_parent().damage
		player_take_damage(itCameFrom, damage)

func _on_hit_box_left_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy") and area.is_in_group("HitBox"):
		var itCameFrom = 1
		damage = area.get_parent().damage
		player_take_damage(itCameFrom, damage)

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "Shoot":
		shooting = false
		isReady = true
		$AnimatedSprite2D.play("idle")