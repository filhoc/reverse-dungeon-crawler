extends Node2D

@export var warrior_scene: PackedScene

@onready var spawn_points: Node2D = $SpawnPoints



var active_warriors = 0

func _ready() -> void:
	spawn_warrior()
	print("")

func spawn_warrior() -> void:
	print("trying to spawn")

	var warrior = warrior_scene.instantiate()
	print("warrior instantiated")

	var points = spawn_points.get_children()
	var spawn_point = points.pick_random()

	get_parent().add_child.call_deferred(warrior)
	warrior.global_position = spawn_point.global_position

	print("warrior added to level")
	print("warrior position: ", warrior.global_position)

	warrior.defeated.connect(_on_warrior_defeated)

	active_warriors += 1

func _on_warrior_defeated() -> void:
	print("spawner detected warrior death")

	GameManager.add_score(1)
	active_warriors -= 1

	spawn_warrior()
	spawn_warrior()
