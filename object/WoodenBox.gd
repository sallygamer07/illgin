extends KinematicBody2D
class_name WoodenBox


var vel = Vector2.ZERO

	
func slide(vector):
	vel = vector
	vel = move_and_slide(vel)
