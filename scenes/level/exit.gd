extends Area3D

var deleted = false

func _on_body_entered(body):
	if body.name == "shifter":
		get_tree().get_first_node_in_group(
			"player").find_child("grab").object = null
		body.queue_free()
		deleted = true
	if body.is_in_group("player") and deleted == true:
		get_tree().change_scene_to_file("res://scenes/player/menu/end.tscn")
