extends RigidBody3D

@onready var sfx = $sfx
@export var shift_forms:Array[forms]
@onready var collision = $collision
@onready var mesh = $mesh
@onready var cooldown = $cooldown
const SHFT = preload("res://sound/shft.wav")
const RUBBER = preload("res://sound/rubber.wav")
var current_shape:int = -1

func _ready():
	set_shape(0)

func set_shape(shape:int):
	if current_shape != shape and cooldown.is_stopped():
		anim_emit()
		collision.set_shape(load(shift_forms[shape].collision_shape))
		mesh.set_mesh(load(shift_forms[shape].mesh_shape))
		set_physics_material_override(load(shift_forms[shape].physics))
		mass = shift_forms[shape].mass
		current_shape = shape
		position.y += 0.5
		
		cooldown.start()
func anim_emit():
	sfx.set_stream(SHFT)
	sfx.play()
	var tween = get_tree().create_tween()
	tween.tween_property(mesh.material_overlay, "emission_enabled", true, 0)
	tween.tween_property(mesh.material_overlay, "emission_energy_multiplier", 0.0, 1.0).from(4.0)
	tween.tween_property(mesh.material_overlay, "emission_enabled", false, 0)
func selection(selected:bool):
	if selected: mesh.material_overlay.next_pass.set_shader_parameter("outline_width",2)
	else: mesh.material_overlay.next_pass.set_shader_parameter("outline_width",0)


func _on_body_entered(_body):
	sfx.set_stream(RUBBER)
	sfx.play()
