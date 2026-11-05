extends CharacterBody2D
@onready var weapon_hitbox: CollisionShape2D = $weapon/weapon_hitbox



const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_attacking: bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("main") and not is_attacking:
		is_attacking = true
		$AnimatedSprite2D.play("main")
		$weapon/weapon_hitbox
	
	if Input.is_action_just_pressed("secondary") and not is_attacking:
		is_attacking = true
		$AnimatedSprite2D.play("secondary")
		$weapon/weapon_hitbox
		
		# Create an automatic 0.4-second timer to reset the attack state
		get_tree().create_timer(0.4).timeout.connect(func(): is_attacking = false)
