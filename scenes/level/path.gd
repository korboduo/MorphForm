@tool
extends Path3D

@export var distance_between_planks = 1.0:
	set(value):
		distance_between_planks = value
		is_dirty = true
	
var is_dirty = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_dirty:
		_update_multimesh()

		is_dirty = false

func _update_multimesh():
	var path_length: float = curve.get_baked_length()
	var count = floor(path_length / distance_between_planks)

	var mm: MultiMesh = $MultiMeshInstance3D.multimesh
	mm.instance_count = count
	var offset = distance_between_planks/2.0

	for i in range(0, count):
		var curve_distance = offset + distance_between_planks * i
		var position_ = curve.sample_baked(curve_distance, true)

		var basis_ = Basis()
		
		var up = curve.sample_baked_up_vector(curve_distance, true)
		var forward = position_.direction_to(curve.sample_baked(curve_distance + 0.1, true))

		basis_.y = up
		basis_.x = forward.cross(up).normalized()
		basis_.z = -forward
		
		var trans = Transform3D(basis_, position_)
		mm.set_instance_transform(i, trans)


func _on_curve_changed():
	is_dirty = true
