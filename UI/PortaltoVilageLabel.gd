extends Control

var finished = false

func _ready():
	$Label.percent_visible = 0
	var _error = $Area2D.connect("body_entered", self, "_play_animation")
	
func _play_animation(_body):
	if _body.is_in_group("player"):
		if Global.loaded == -1 or Global.loaded == 0:
			if finished == false:
				$AnimationPlayer.play("show")
				finished = true
			else:
				$Label.percent_visible = 0
		else:
			hide()
