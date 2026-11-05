extends Control

const PLAY_SCENE_PATH := "res://level_1.tscn"
const GALLERY_SCENE_PATH := "res://sceen/gallery.tscn"
const CREDITS_SCENE_PATH := "res://sceen/credits.tscn"

@onready var play_button: Button = $"level 1"
@onready var gallery_button: Button = $gallery
@onready var credits_button: Button = $credits
@onready var exit_button: Button = $exit


func _ready() -> void:
	# The button artwork and labels are baked into the menu background texture.
	# Keep the controls transparent so they act as clickable hotspots over it.
	for button in [play_button, gallery_button, credits_button, exit_button]:
		button.flat = true
		button.focus_mode = Control.FOCUS_NONE
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	play_button.pressed.connect(_on_play_button_pressed)
	gallery_button.pressed.connect(_on_gallery_button_pressed)
	credits_button.pressed.connect(_on_credits_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)


func _on_play_button_pressed() -> void:
	_open_scene(PLAY_SCENE_PATH)


func _on_gallery_button_pressed() -> void:
	_open_scene(GALLERY_SCENE_PATH)


func _on_credits_button_pressed() -> void:
	_open_scene(CREDITS_SCENE_PATH)


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _open_scene(scene_path: String) -> void:
	var error := get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("Could not open scene '%s' (error %d)." % [scene_path, error])
