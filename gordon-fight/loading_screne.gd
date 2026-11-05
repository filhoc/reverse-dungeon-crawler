extends Control

# Target scene paths matching your exact file names
@export_file("level_1.tscn") var loading_screen_path: String = "res://LoadingScreen.tscn"
@export_file("gallery.tscn") var gallery_scene_path: String = "res://gallary.tscn"
@export_file("credits.tscn") var credits_scene_path: String = "res://credits.tscn"

# Play button -> open loading screen
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(loading_screen_path)

# Gallery button -> open gallery
func _on_gallery_button_pressed() -> void:
	get_tree().change_scene_to_file(gallery_scene_path)

# Credits button -> open credits
func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file(credits_scene_path)

# Exit button -> quit game
func _on_exit_button_pressed() -> void:
	get_tree().quit()
