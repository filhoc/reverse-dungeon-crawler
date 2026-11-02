extends Area2D

var damage = 1000

func _on_body_entered(body):
	print("warrior touched attack hitbox")
	if body.is_in_group("enemies"):
		print("object is enemy")
		body.take_damage(damage)
