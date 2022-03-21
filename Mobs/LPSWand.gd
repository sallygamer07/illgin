extends Node2D

var SP = preload("res://Mobs/SPEffect.tscn")


var can_SP = true

var SP_rate = 0.7
var deg_for_SP : float

var SP_ap = 8

func _ready():
	Global.LPS_wand = self


func Attack(_target_):
	var target_pos : Vector2 = position
	deg_for_SP = target_pos.angle_to_point(global_position)
	look_at(target_pos)
	

	if can_SP:
		var SP_instance = SP.instance()
		SP_instance.player = _target_
		SP_instance.position = get_parent().position
		SP_instance.rotation_degrees = rotation_degrees
		get_tree().get_root().add_child(SP_instance)
		can_SP = false
		yield(get_tree().create_timer(SP_rate), "timeout")
		can_SP = true
