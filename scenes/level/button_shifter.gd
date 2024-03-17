extends Area3D
signal pressed

const PRESSED = preload("res://sound/pressed.mp3")

func _on_checker_body_entered(body):
	if body == $buttonPhys:
		pressed.emit()
		$audio.set_stream(PRESSED)
		$audio.play()
		$spot.light_color = Color.TOMATO
		get_tree().get_first_node_in_group("player").start_hint.emit()
		$checker.set_deferred("monitoring", false)
