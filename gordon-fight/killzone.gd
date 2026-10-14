extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print("you died")
	print(body)
	get_tree().reload_current_scene()
