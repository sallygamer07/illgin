extends Control

func _ready():
	$Slot1/delete.hide()
	$Slot2/delete2.hide()
	$Slot3/delete3.hide()
	$Slot4/delete4.hide()
	$Slot5/delete5.hide()
	$Slot6/delete6.hide()

func _process(_delta):
	if SaveFile.is_file_there(1):
		$Slot1/Label.text = "Level : " + str(SaveFile._player_data["player_level"]) + "\n" + "Coin : " + str(SaveFile._player_data["coin"])
		$Slot1/delete.show()
	else:
		$Slot1/LoadSlot1.disabled = true
		$Slot1/Label.text = "빈 슬롯"
		$Slot1/delete.hide()
		
		
	if SaveFile.is_file_there(2):
		$Slot2/Label2.text = "Level : " + str(SaveFile._player_data["player_level"]) + "\n" + "Coin : " + str(SaveFile._player_data["coin"])
		$Slot2/delete2.show()
	else:
		$Slot2/LoadSlot2.disabled = true
		$Slot2/Label2.text = "빈 슬롯"
		$Slot2/delete2.hide()
		
		
	if SaveFile.is_file_there(3):
		$Slot3/Label3.text = "Level : " + str(SaveFile._player_data["player_level"]) + "\n" + "Coin : " + str(SaveFile._player_data["coin"])
		$Slot3/delete3.show()
	else:
		$Slot3/LoadSlot3.disabled = true
		$Slot3/Label3.text = "빈 슬롯"
		$Slot3/delete3.hide()
		
		
	if SaveFile.is_file_there(4):
		$Slot4/Label4.text = "Level : " + str(SaveFile._player_data["player_level"]) + "\n" + "Coin : " + str(SaveFile._player_data["coin"])
		$Slot4/delete4.show()
	else:
		$Slot4/LoadSlot4.disabled = true
		$Slot4/Label4.text = "빈 슬롯"
		$Slot4/delete4.hide()
		
		
	if SaveFile.is_file_there(5):
		$Slot5/Label5.text = "Level : " + str(SaveFile._player_data["player_level"]) + "\n" + "Coin : " + str(SaveFile._player_data["coin"])
		$Slot5/delete5.show()
	else:
		$Slot5/LoadSlot5.disabled = true
		$Slot5/Label5.text = "빈 슬롯"
		$Slot5/delete5.hide()
		
		
	if SaveFile.is_file_there(6):
		$Slot6/Label6.text = "Level : " + str(SaveFile._player_data["player_level"]) + "\n" + "Coin : " + str(SaveFile._player_data["coin"])
		$Slot6/delete6.show()
	else:
		$Slot6/LoadSlot6.disabled = true
		$Slot6/Label6.text = "빈 슬롯"
		$Slot6/delete6.hide()
		
func change_load_scene():
	get_parent().get_node("Main").stop()
	$FadeScene.transition()

func _on_LoadSlot1_pressed():
	Global.loaded = 1
	SaveFile.load_file(1)
	change_load_scene()

func _on_LoadSlot2_pressed():
	Global.loaded = 2
	SaveFile.load_file(2)
	change_load_scene()
	
func _on_LoadSlot3_pressed():
	Global.loaded = 3
	SaveFile.load_file(3)
	change_load_scene()


func _on_LoadSlot4_pressed():
	Global.loaded = 4
	SaveFile.load_file(4)
	change_load_scene()


func _on_LoadSlot5_pressed():
	Global.loaded = 5
	SaveFile.load_file(5)
	change_load_scene()


func _on_LoadSlot6_pressed():
	Global.loaded = 6
	SaveFile.load_file(6)
	change_load_scene()


func _on_Back_pressed():
	hide()


func _on_delete_pressed():
	SaveFile.delete_file(1)
	
func _on_delete2_pressed():
	SaveFile.delete_file(2)


func _on_delete3_pressed():
	SaveFile.delete_file(3)


func _on_delete4_pressed():
	SaveFile.delete_file(4)


func _on_delete5_pressed():
	SaveFile.delete_file(5)


func _on_delete6_pressed():
	SaveFile.delete_file(6)



func _on_FadeScene_transitioned():
	SceneChanger.goto_scene("res://level/" + SaveFile._player_data["level"] + ".tscn", get_parent())
