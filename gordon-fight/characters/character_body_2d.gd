extends CharacterBody2D

@onready var weapon: Area2D = $weapon
@onready var weapon_hitbox: CollisionShape2D = $weapon/weapon_hitbox
@onready var health_bar := get_node_or_null("beman_healthbar") as ProgressBar

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ATTACK_COOLDOWN := 3.0

var is_attacking: bool = false
var primary_attack_on_cooldown: bool = false
var secondary_attack_on_cooldown: bool = false

var max_health = 50
var health = 50
var is_dead: bool = false


func _ready() -> void:
	get_tree().paused = false
	if health_bar != null:
		health_bar.max_value = max_health
		health_bar.value = health


func take_damage(damage: int) -> void:
	if is_dead:
		return

	health = max(health - damage, 0)
	if health_bar != null:
		health_bar.value = health

	print("you took ", damage, " damage")

	if health == 0:
		is_dead = true
		var error := get_tree().change_scene_to_file("res://angle map.tscn")
		if error != OK:
			push_error("Could not open the Angel map (error %d)." % error)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var secondary_action_pressed := Input.is_action_just_pressed("secondary_attack")
	var primary_action_pressed := Input.is_action_just_pressed("primary_attack")
	var attack_animation := ""
	if secondary_action_pressed and not secondary_attack_on_cooldown and not is_attacking:
		secondary_attack_on_cooldown = true
		attack_animation = "main"
		get_tree().create_timer(ATTACK_COOLDOWN).timeout.connect(func():
			secondary_attack_on_cooldown = false
		)
	elif primary_action_pressed and not primary_attack_on_cooldown and not is_attacking:
		primary_attack_on_cooldown = true
		attack_animation = "secondary"
		get_tree().create_timer(ATTACK_COOLDOWN).timeout.connect(func():
			primary_attack_on_cooldown = false
		)

	if attack_animation != "":
		is_attacking = true
		$AnimatedSprite2D.play(attack_animation)
		$weapon/weapon_hitbox.set_deferred("disabled", false)

		get_tree().create_timer(0.3).timeout.connect(func():
			$weapon/weapon_hitbox.set_deferred("disabled", true)
			is_attacking = false
		)

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
			$AnimatedSprite2D.play("default")
		else:
			$AnimatedSprite2D.play("default")

	move_and_slide()
