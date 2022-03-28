extends Area2D


export(String) var get_item_name = ""

var player_enter = false



func _input(event):
	if event.is_action_pressed("interect"):
		if player_enter == true:
			PlayerInventory.add_item(get_item_name, 1)
			player_enter = false

func _on_GetBook_body_entered(body):
	if body.is_in_group("player"):
		player_enter = true


func _on_GetBook_body_exited(_body):
	if _body.is_in_group("player"):
		player_enter = false
