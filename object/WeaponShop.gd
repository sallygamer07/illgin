extends StaticBody2D

	
func _on_InPlayer_body_entered(body):
	if body.is_in_group("player"):
		Global.player_in_shop = "WeaponShop"

func _on_InPlayer_body_exited(body):
	if body.is_in_group("player"):
		Global.player_in_shop = null
