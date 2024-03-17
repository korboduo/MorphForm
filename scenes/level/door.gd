extends CSGBox3D

@export var connected_button:Node3D
@export var height:float = 0.0
var initHeight:float 

func _ready():
	connected_button.pressed.connect(_on_pressed)
	initHeight = position.y

func _on_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", height, 0.5)
