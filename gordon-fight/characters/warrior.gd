extends Node2D

@onready var killzone: Area2D = $killzone
@onready var collision_shape_2d: CollisionShape2D = $killzone/CollisionShape2D

@export var speed: float = 80.0

var player: CharacterBody2D
var target: Marker2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	target = player.getnode("enemy_target")
	
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
			

func _on_hurtbox_area_entered(area: Area2D) -> void:
	queue_free()
