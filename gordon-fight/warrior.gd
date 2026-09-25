extends Node2D

@export var speed: float = 100.0
@export var gravity: float = 1000.0

var player: CharacterBody2D
var vertical_velocity: float = 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _process(delta: float) -> void:
	if player:
		# Follow the player left and right
		var direction = global_position.direction_to(player.global_position)

		global_position.x += direction.x * speed * delta

	# Gravity
	vertical_velocity += gravity * delta
	global_position.y += vertical_velocity * delta
