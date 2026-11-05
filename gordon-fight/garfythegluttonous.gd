extends CharacterBody2D
@onready var firebreath: Area2D = $firebreath
@onready var fire: AnimatedSprite2D = $firebreath/fire
@onready var fire_hitbox: CollisionPolygon2D = $firebreath/fire_hitbox
@onready var bellyflop: Area2D = $bellyflop
@onready var flop_hitbox: CollisionShape2D = $bellyflop/flop_hitbox




const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_attacking: bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("primary_attack") and not is_attacking:
		is_attacking = true
		$AnimatedSprite2D.play("breathe_fire")
		$firebreath/fire.play("default")
		$firebreath/fire_hitbox.disabled = false
		
		# Create an automatic 0.4-second timer to reset the attack state
		get_tree().create_timer(0.6).timeout.connect(func(): is_attacking = false)
		
	if Input.is_action_just_pressed("secondary_attack") and not is_attacking:
		is_attacking = true
		$AnimatedSprite2D.play("belly_flop")
		$bellyflop/flop_hitbox.disabled = false
		
		get_tree().create_timer(0.6).timeout.connect(func(): is_attacking = false)

	var direction := Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			$AnimatedSprite2D.flip_h = true
		elif direction < 0:
			$AnimatedSprite2D.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not is_attacking:
		if direction != 0:
			$AnimatedSprite2D.play("roll")
		else:
			$AnimatedSprite2D.play("idle")

	move_and_slide()
