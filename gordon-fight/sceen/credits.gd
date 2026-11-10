extends Control


func _on_exit_button_pressed() -> void:
	var error := get_tree().change_scene_to_file("res://control.tscn")
	if error != OK:
		push_error("Could not return to the loading screen (error %d)." % error)
