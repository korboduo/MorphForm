extends ColorRect

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func _on_restart_button_down():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
func _on_quit_button_up():
	get_tree().quit()
