extends Control

# Update these paths to match your actual scene file paths in the FileSystem dock
@export_file("res://level_1.tscn") var loading_screen_path: String = "res://level_1.tscn"
@export_file("*.tscn") var gallery_scene_path: String = "res://Gallery.tscn"
@export_file("*.tscn") var credits_scene_path: String = "res://Credits.tscn"

# Triggered when the Play button is pressed
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(res://level_1.tscn)

# Triggered when the Gallery button is pressed
func _on_gallery_button_pressed() -> void:
	get_tree().change_scene_to_file(gallery_scene_path)

# Triggered when the Credits button is pressed
func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file(credits_scene_path)

# Triggered when the Exit button is pressed
func _on_exit_button_pressed() -> void:
	get_tree().quit()
