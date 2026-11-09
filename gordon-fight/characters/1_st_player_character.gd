extends CharacterBody2D

@onready var weapon: Area2D = $weapon
@onready var weapon_hitbox: CollisionShape2D = $weapon/weapon_hitbox
@onready var health_bar: ProgressBar = $beman_healthbar

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_attacking: bool = false

var max_health = 30
var health = 30


func _ready() -> void:
	health_bar.max_value = max_health
	health_bar.value = health


func take_damage(damage: int) -> void:
	health -= damage
	health_bar.value = health

	print("you took ", damage, " damage")

	if health <= 0:
		get_tree().reload_current_scene()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("primary_attack") and not is_attacking:
		is_attacking = true
		$AnimatedSprite2D.play("attack")
		$weapon/weapon_hitbox.disabled = false
		get_tree().create_timer(0.5).timeout.connect(func(): is_attacking = false)

	var direction := Input.get_axis("left", "right")

	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			$AnimatedSprite2D.flip_h = true
			$weapon/weapon_hitbox.position.x = 24
		elif direction < 0:
			$AnimatedSprite2D.flip_h = false
			$weapon/weapon_hitbox.position.x = -24
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not is_attacking:
		if direction != 0:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")

		move_and_slide()
			


	
