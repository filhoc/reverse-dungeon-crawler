extends CharacterBody2D
@onready var weapon_hitbox: CollisionShape2D = $weapon/weapon_hitbox



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
		$AnimatedSprite2D.play("main")
		$weapon/weapon_hitbox
	
		
		# Create an automatic 0.4-second timer to reset the attack state
		get_tree().create_timer(0.4).timeout.connect(func(): is_attacking = false)

	var direction := Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not is_attacking:
		if direction > 0:
			$AnimatedSprite2D.play("right")
		elif direction < 0:
			$AnimatedSprite2D.play("left")
		else:
			$AnimatedSprite2D.play("jump")

	
		
		
	move_and_slide()
