extends AudioStreamPlayer3D

@onready var foot_timer = $"../footTimer"
func _physics_process(_delta):
	var speed = Vector2(owner.velocity.x, owner.velocity.z).length()
	if speed > 1 and owner.is_on_floor():
		if foot_timer.is_stopped(): foot_timer.start()
	elif !foot_timer.is_stopped(): foot_timer.stop()
	

func _on_foot_timer_timeout():
	play()
