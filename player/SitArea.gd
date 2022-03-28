extends Area2D
class_name sitArea

onready var sitPos : Position2D = get_node("sitPosition")

func _on_SitArea_body_entered(body):
	if body.is_in_group("player"):
		body.sitArea = self

func _on_SitArea_body_exited(body):
	if body.is_in_group("player"):
		if body.sitArea == self:
			body.sitArea = null

