extends Node2D

@onready var killzone: Area2D = $killzone
@onready var collision_shape_2d: CollisionShape2D = $killzone/CollisionShape2D

@export var speed: float = 80.0



var player: CharacterBody2D
var target: Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player == null and get_tree().current_scene != null:
		player = get_tree().current_scene.get_node_or_null("gorrila") as CharacterBody2D
	if player == null:
		set_process(false)
		return

	target = player.get_node_or_null("enemy_target") as Node2D
	if target == null:
		target = player
	
func _process(delta: float) -> void:
	if player:
		var direction = sign(target.global_position.x - global_position.x)

		global_position.x += direction * speed * delta

		# Face the direction the warrior moves
		if direction < 0 and not killzone.enemy_attacking:
			
			$AnimatedSprite2D.flip_h = true
			animated_sprite_2d.play("run")
			
			
		elif direction > 0 and not killzone.enemy_attacking:
			$AnimatedSprite2D.flip_h = false
			animated_sprite_2d.play("run") 
			
signal defeated

func _on_hurtbox_area_entered(area: Area2D) -> void:
	GameManager.score += 1
	print("warrior killed")
	defeated.emit()
	queue_free()
