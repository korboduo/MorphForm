extends ColorRect

func _ready():
	get_tree().paused = true
	TranslationServer.set_locale("en")
	await get_tree().create_timer(4).timeout
	$boot.hide()

func _input(event):
	if event.is_action_pressed("menu"):
		if visible: hide()
		else: show()

func _on_visibility_changed():
	if visible: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = visible

func _on_settings_button_up():
	%main.hide()
	%settings.show()
func _on_play_button_up():
	hide()
func _on_quit_button_up():
	get_tree().quit()
func _on_sens_slider_value_changed(value):
	Settings.mouseSens = value
func _on_vol_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
func _on_vs_check_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
func _on_fs_check_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
func _on_lang_opt_item_selected(index):
	if index == 0: TranslationServer.set_locale("en")
	elif index == 1: TranslationServer.set_locale("ru")
func _on_back_button_up():
	%main.show()
	%settings.hide()
func _on_reflection_check_toggled(toggled_on):
	for i in get_tree().get_nodes_in_group("reflector"):
		i.visible = toggled_on
