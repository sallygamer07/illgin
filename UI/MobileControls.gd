extends CanvasLayer

signal use_move_vector

onready var movement = $Movement
onready var inner = $InCircle

var move_vector = Vector2.ZERO
var joyStick_active = true

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if movement.is_pressed():
			move_vector = calculate_move_vector(event.position)
			joyStick_active = true
			inner.position = event.position
			inner.visible = true
			
			
	if event is InputEventScreenTouch:
		if event.pressed == false:
			joyStick_active = false
			inner.visible = false
			
func _physics_process(_delta):
	if joyStick_active:
		emit_signal("use_move_vector", move_vector)

func calculate_move_vector(event_position):
	var tex_center = movement.position + Vector2(64, 64)
	return (event_position - tex_center).normalized()
