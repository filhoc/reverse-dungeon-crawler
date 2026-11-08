extends Node2D

@export var speed: float = 80.0

var player: CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	player = get_parent().get_node("1st player character")

func _process(delta: float) -> void:
	if player:
		var direction = sign(player.global_position.x - global_position.x)

		global_position.x += direction * speed * delta

		# Face the direction the warrior moves
		if direction < 0:
			
			$AnimatedSprite2D.flip_h = true
			animated_sprite_2d.play("run")
			
			
		elif direction > 0:
			$AnimatedSprite2D.flip_h = false
			animated_sprite_2d.play("run") 
			
			

			



func _on_hurtbox_area_entered(area: Area2D) -> void:
	queue_free()
