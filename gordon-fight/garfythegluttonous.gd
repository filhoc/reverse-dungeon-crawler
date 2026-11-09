extends CharacterBody2D
@onready var firebreath: Area2D = $firebreath
@onready var fire: AnimatedSprite2D = $firebreath/fire
@onready var fire_hitbox: CollisionPolygon2D = $firebreath/fire_hitbox
@onready var bellyflop: Area2D = $bellyflop
@onready var flop_hitbox: CollisionShape2D = $bellyflop/flop_hitbox
@onready var garfy_healthbar: ProgressBar = $garfy_healthbar


var jumping

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_attacking: bool = false

var max_health = 150
var health = 150


func _ready() -> void:
	garfy_healthbar.max_value = max_health
	garfy_healthbar.value = health


func take_damage(damage: int) -> void:
	health -= damage
	garfy_healthbar.value = health

	print("you took ", damage, " damage")

	if health <= 0:
		get_tree().reload_current_scene()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumping = true
		get_tree().create_timer(0.6).timeout.connect(func(): jumping = false)

	if Input.is_action_just_pressed("primary_attack") and not is_attacking and jumping:
		is_attacking = true
		$AnimatedSprite2D.play("belly_flop (primary)")
		$bellyflop/flop_hitbox.disabled = false
		
		get_tree().create_timer(0.7).timeout.connect(func(): is_attacking = false)
		
	if Input.is_action_just_pressed("secondary_attack") and not is_attacking:
		is_attacking = true
		$AnimatedSprite2D.play("breathe_fire (secondary)")
		$firebreath/fire.play("default")
		$firebreath/fire_hitbox.disabled = false
		
		get_tree().create_timer(0.6).timeout.connect(func(): is_attacking = false)


	var direction := Input.get_axis("left", "right")

	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			$AnimatedSprite2D.flip_h = true
			$firebreath/fire.flip_h = true
			$firebreath/fire.position.x = 450
			$firebreath/fire_hitbox.position.x = 450
			
		elif direction < 0:
			$AnimatedSprite2D.flip_h = false
			$firebreath/fire.flip_h = false
			$firebreath/fire.position.x = -247
			$firebreath/fire_hitbox.position.x = -247
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not is_attacking:
		if direction != 0:
			$AnimatedSprite2D.play("roll")
		else:
			$AnimatedSprite2D.play("idle")

		move_and_slide()
			
