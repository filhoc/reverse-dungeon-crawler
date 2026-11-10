extends Control

const LOADING_SCREEN_PATH := "res://control.tscn"
const INTRO_STATE_PATH := "user://game_state.cfg"
const SHEET_PATH := "res://Intro animation.png"
const FRAME_SIZE := 64
const SHEET_COLUMNS := 14
const FRAME_COUNT := 200
const INTRO_FPS := 24.0

@onready var intro_animation: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	var saved_state := ConfigFile.new()
	if saved_state.load(INTRO_STATE_PATH) == OK and saved_state.get_value("intro", "played", false):
		_open_loading_screen()
		return

	if not _build_intro_animation():
		return
	intro_animation.animation_finished.connect(_on_intro_animation_finished)
	intro_animation.play("intro")


func _build_intro_animation() -> bool:
	var sheet := load(SHEET_PATH) as Texture2D
	if sheet == null:
		push_error("Could not load the intro animation sheet.")
		_open_loading_screen()
		return false

	var frames := SpriteFrames.new()
	frames.add_animation("intro")
	frames.set_animation_speed("intro", INTRO_FPS)
	frames.set_animation_loop("intro", false)

	for frame_index in range(FRAME_COUNT):
		var column := frame_index % SHEET_COLUMNS
		var row := int(frame_index / SHEET_COLUMNS)
		var frame := AtlasTexture.new()
		frame.atlas = sheet
		frame.region = Rect2(column * FRAME_SIZE, row * FRAME_SIZE, FRAME_SIZE, FRAME_SIZE)
		frames.add_frame("intro", frame)

	intro_animation.sprite_frames = frames
	intro_animation.animation = "intro"
	var viewport_size := get_viewport_rect().size
	var fit_scale: float = minf(viewport_size.x, viewport_size.y) * 0.92 / float(FRAME_SIZE)
	intro_animation.position = viewport_size / 2.0
	intro_animation.scale = Vector2.ONE * fit_scale
	return true


func _on_intro_animation_finished() -> void:
	var saved_state := ConfigFile.new()
	saved_state.set_value("intro", "played", true)
	var save_error := saved_state.save(INTRO_STATE_PATH)
	if save_error != OK:
		push_error("Could not save the intro playback state (error %d)." % save_error)
	_open_loading_screen()


func _open_loading_screen() -> void:
	var error := get_tree().change_scene_to_file(LOADING_SCREEN_PATH)
	if error != OK:
		push_error("Could not open the loading screen (error %d)." % error)
