extends Control

@onready var final_score_label: Label = $FinalScoreLabel
@onready var loading_screen_button: Button = $LoadingScreenButton


func _ready() -> void:
	final_score_label.text = "Final Score: %d" % GameManager.final_score
	loading_screen_button.pressed.connect(_on_loading_screen_button_pressed)


func _on_loading_screen_button_pressed() -> void:
	var error := get_tree().change_scene_to_file("res://control.tscn")
	if error != OK:
		push_error("Could not return to the loading screen (error %d)." % error)
