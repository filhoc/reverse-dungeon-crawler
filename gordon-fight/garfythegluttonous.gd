extends CharacterBody2D
@onready var firebreath: Area2D = $firebreath
@onready var fire: AnimatedSprite2D = $firebreath/fire
@onready var fire_hitbox: CollisionPolygon2D = $firebreath/fire_hitbox
@onready var bellyflop: Area2D = $bellyflop
@onready var flop_hitbox: CollisionShape2D = $bellyflop/flop_hitbox
@onready var garfy_healthbar: ProgressBar = $garfy_healthbar

var belly_flopping = false
const FLOP_SPEED = 700.0
var jumping
var landing_pause = false

const SPEED = 300.0
const JUMP_VELOCITY = -700.0

var is_attacking: bool = false

var max_health = 300
var health = 300



func _ready() -> void:
	garfy_healthbar.max_value = max_health
	garfy_healthbar.value = health
	
	fire_hitbox.disabled = true
	flop_hitbox.disabled = true


func take_damage(damage: int) -> void:

	health -= damage
	garfy_healthbar.value = health

	print("you took ", damage, " damage")

	if health <= 0:
		GameManager.final_score = GameManager.score
		var error := get_tree().change_scene_to_file("res://lose.tscn")
		if error != OK:
			push_error("Could not open the Lose scene (error %d)." % error)


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and not landing_pause:
		velocity.y = JUMP_VELOCITY
		jumping = true

	if Input.is_action_just_pressed("primary_attack") and not is_attacking and jumping:
		is_attacking = true
		belly_flopping = true

		$AnimatedSprite2D.play("belly_flop (primary)")
		velocity.y = FLOP_SPEED

		flop_hitbox.set_deferred("disabled", false)
		
		
	if Input.is_action_just_pressed("secondary_attack") and not is_attacking:
		is_attacking = true
		$AnimatedSprite2D.play("breathe_fire (secondary)")
		$firebreath/fire.play("default")
		$firebreath/fire_hitbox.disabled = false
		
		get_tree().create_timer(0.6).timeout.connect(disable_fire)
		



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

	if not is_attacking and not landing_pause:
		if direction != 0:
			$AnimatedSprite2D.play("roll")
		else:
			$AnimatedSprite2D.play("idle")

	move_and_slide()

	if belly_flopping and is_on_floor():
		flop_hitbox.set_deferred("disabled", true)

		belly_flopping = false
		jumping = false
		landing_pause = true

		$AnimatedSprite2D.play("belly_flop (primary)")

		get_tree().create_timer(0.3).timeout.connect(func():
			landing_pause = false
			is_attacking = false
		)

func disable_fire():
		$firebreath/fire_hitbox.set_deferred("disabled", true)
		is_attacking = false	
