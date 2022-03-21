extends Control


func _process(_delta):
	if Global.player != null:
		$cash.text = str(Global.player.coin)


func _on_Yes_pressed():
	Global.active_shop = false
	self.visible = false
	$Ask.hide()


func _on_No_pressed():
	$Ask.hide()


func _on_exit_pressed():
	$Ask/Label.text = "정말 상점을 나가시겠습니까?"
	$Ask.show()
