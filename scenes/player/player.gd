extends CharacterBody3D

@onready var head = $head
@onready var eyes = $head/eyes
const freq = 2.95
const amp = 0.002
const speed = 4.5
const moustLimit = deg_to_rad(85)
const gravity = 16.0
const jumpVel = 6
var inertia: float
var mouse_input
var time:float
var standing:bool = true

signal start_hint

func _ready():
	Input.set_use_accumulated_input(false)

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		gather_mouse_input(event)
		rotate_y(-mouse_input.x)
		head.rotate_x(-mouse_input.y)
		head.rotation.x = clamp(head.rotation.x, -moustLimit, moustLimit)
	if event.is_action_pressed("jump") and is_on_floor(): velocity.y = jumpVel
	if event.is_action("ads"):
		if event.is_pressed(): animate_fov(35)
		else:animate_fov(75)
	
	if event is InputEventKey:
		if event.physical_keycode == KEY_F4 and event.is_pressed():
			global_position = $"/root/game/goto".global_position

func gather_mouse_input(event: InputEventMouseMotion):
	mouse_input = Vector2.ZERO
	var viewport_transform := get_tree().root.get_final_transform()
	mouse_input += event.xformed_by(viewport_transform).relative
	mouse_input *= Settings.mouseSens * 0.0001

func _process(delta):
	if is_on_floor():
		inertia = 10
	else:
		velocity.y -= gravity*delta
		inertia = 1
	cam_wave(delta)
	locomotion(delta)
	move_and_slide()

func locomotion(delta):
	var input  = Input.get_vector("left", "right", "up", "down")
	var direction = (global_basis * Vector3(input.x, 0, input.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x*speed,delta*inertia)
		velocity.z = lerp(velocity.z, direction.z*speed,delta*inertia)
	else:
		velocity.x = lerp(velocity.x, 0.0, delta*inertia)
		velocity.z = lerp(velocity.z, 0.0, delta*inertia)

func cam_wave(delta):
	var spedometer = Vector2(velocity.x, velocity.z).length()
	time += delta * spedometer * float(is_on_floor())
	var vertical = sin(time*freq)*amp
	var horizotal = cos(time*freq/2)*amp
	eyes.rotation = Vector3(vertical, horizotal, 0.0)

func animate_fov(target_fov:float):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(eyes, "fov", target_fov, 0.5)
