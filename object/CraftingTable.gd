extends Node2D



func _on_PlayerDetection_body_entered(body):
	if body is Player:
		Global.crafting_table = true


func _on_PlayerDetection_body_exited(body):
	if body is Player:
		Global.crafting_table = false
