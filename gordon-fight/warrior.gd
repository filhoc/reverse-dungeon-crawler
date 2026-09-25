extends CharacterBody2D

@export var speed: float = 100.0

var player: CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	if player:
		# Find the direction to the player
		var direction = global_position.direction_to(player.global_position)

		# Move towards the player
		velocity = direction * speed
		move_and_slide()
