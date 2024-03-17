extends MarginContainer

@onready var facing = $facing
var hints_passed:int = -1

func _ready():
	%grab.hud_event.connect(on_grabber)
	owner.start_hint.connect(on_hint)
	on_hint()


func on_grabber(event):
	if event == "facing_wall": show_node(facing)

func on_hint():
	if hints_passed < 4:
		hints_passed += 1
		await get_tree().create_timer(4).timeout
		match hints_passed:
			0: show_node($pick)
			1: 
				show_node($reset)
				await get_tree().create_timer(6).timeout
				show_node($shift)
			2: 
				show_node($jump)
				await get_tree().create_timer(6).timeout
				show_node($zoom)

func show_node(node:Control):
	var tween = get_tree().create_tween()
	tween.tween_property(node, "modulate:a", 1.0, 0.25)
	tween.tween_property(node, "modulate:a", 1.0, 3.0)
	tween.tween_property(node, "modulate:a", 0.0, 0.25)
