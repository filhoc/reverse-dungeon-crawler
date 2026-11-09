extends Node2D

const LOADING_SCREEN_PATH := "res://control.tscn"

var pause_layer: CanvasLayer


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo or key_event.keycode != KEY_ESCAPE:
		return
	if get_tree().paused:
		return

	get_viewport().set_input_as_handled()
	_show_pause_menu()


func _show_pause_menu() -> void:
	get_tree().paused = true

	pause_layer = CanvasLayer.new()
	pause_layer.name = "PauseMenu"
	pause_layer.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	add_child(pause_layer)

	var overlay := Control.new()
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	pause_layer.add_child(overlay)

	var dimmer := ColorRect.new()
	dimmer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dimmer.color = Color(0.0, 0.0, 0.0, 0.5)
	dimmer.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.add_child(dimmer)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)

	var buttons := VBoxContainer.new()
	buttons.add_theme_constant_override("separation", 24)
	center.add_child(buttons)

	var return_button := _make_pause_button("return")
	return_button.pressed.connect(_resume_game)
	buttons.add_child(return_button)

	var exit_button := _make_pause_button("exit")
	exit_button.pressed.connect(_return_to_loading_screen)
	buttons.add_child(exit_button)


func _make_pause_button(label: String) -> Button:
	var button := Button.new()
	button.text = label
	button.custom_minimum_size = Vector2(440.0, 92.0)
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_font_size_override("font_size", 32)
	button.add_theme_color_override("font_color", Color(0.04, 0.04, 0.04))
	button.add_theme_color_override("font_hover_color", Color(0.04, 0.04, 0.04))
	button.add_theme_color_override("font_pressed_color", Color(0.04, 0.04, 0.04))

	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.48, 0.48, 0.48)
	normal.corner_radius_top_left = 28
	normal.corner_radius_top_right = 28
	normal.corner_radius_bottom_left = 28
	normal.corner_radius_bottom_right = 28
	button.add_theme_stylebox_override("normal", normal)

	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color(0.58, 0.58, 0.58)
	button.add_theme_stylebox_override("hover", hover)

	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color(0.38, 0.38, 0.38)
	button.add_theme_stylebox_override("pressed", pressed)
	return button


func _resume_game() -> void:
	get_tree().paused = false
	pause_layer.queue_free()
	pause_layer = null


func _return_to_loading_screen() -> void:
	get_tree().paused = false
	var error := get_tree().change_scene_to_file(LOADING_SCREEN_PATH)
	if error != OK:
		push_error("Could not return to the loading screen (error %d)." % error)
