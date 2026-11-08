extends Area2D

var health = 100

@onready var killzone_shape: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"

var enemy_attacking = false

func _ready() -> void:
	var cycle_timer = Timer.new()
	cycle_timer.wait_time = 2.0
	cycle_timer.one_shot = false
	cycle_timer.autostart = true
	add_child(cycle_timer)
	cycle_timer.timeout.connect(_on_cycle_timeout)
	
	killzone_shape.set_deferred("disabled", true)

func _on_cycle_timeout() -> void:
	killzone_shape.set_deferred("disabled", false)
	enemy_attacking = true
	
	$"../AnimatedSprite2D".play("attack")
	
	await get_tree().create_timer(0.5).timeout
	killzone_shape.set_deferred("disabled", true)
	enemy_attacking = false

func _on_body_entered(body: Node2D) -> void:
	print("damage taken")
	print(body)
	
	health -= 10
	
	if health <= 0:
		get_tree().reload_current_scene()
