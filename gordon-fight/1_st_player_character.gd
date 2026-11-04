extends CharacterBody2D

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
		$AnimatedSprite2D.play("attack")
		
		# Create an automatic 0.4-second timer to reset the attack state
		get_tree().create_timer(0.4).timeout.connect(func(): is_attacking = false)

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
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")

	move_and_slide()
