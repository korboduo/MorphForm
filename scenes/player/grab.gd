extends Node

var object:RigidBody3D = null
var holding:bool = false
var strength:float = 4.0
signal hud_event

func _ready():
	%grabRay.add_exception(owner)

func _unhandled_input(event):
	if event is InputEventKey and object:
		if event.is_action_pressed("reset"):
			if %grabRay.is_colliding():
				hud_event.emit("facing_wall")
			else:
				object.sleeping = true
				object.set_deferred("global_position", (%grabRay.global_position-%grabRay.global_basis.z))
				object.anim_emit()
		match event.physical_keycode:
			KEY_1:
				object.set_shape(0)
			KEY_2:
				object.set_shape(1)
			KEY_3:
				object.set_shape(2)

func _physics_process(_delta):
	if %grabRay.is_colliding() and %grabRay.get_collider().is_in_group("shifter"):
		%grabRay.get_collider().selection(true)
		if Input.is_action_just_pressed("use"):
			object = %grabRay.get_collider()
			object.set_collision_layer_value(2, false)
			object.lock_rotation = true
			holding = true
	elif object: object.selection(false)
	if Input.is_action_just_released("use"):
		if object:
			object.lock_rotation = false
			object.set_collision_layer_value(2, true)
			object.apply_central_impulse((
				object.global_position-%grabRay.global_position).normalized()*strength)
			holding = false
	
	if object and holding:
		object.set_linear_velocity((
			%grabPoint.global_position-object.global_position)*strength)
