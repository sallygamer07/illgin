extends Control


func _ready():
	$Slot1/delete.hide()
	$Slot2/delete2.hide()
	$Slot3/delete3.hide()
	$Slot4/delete4.hide()
	$Slot5/delete5.hide()
	$Slot6/delete6.hide()

	if SaveFile.is_file_there(1):
		$Slot1/Label.text = "Level : " + str(SaveFile._player_data["player_level"]) + "\n" + "Coin : " + str(SaveFile._player_data["coin"])
		$Slot1/delete.show()
	else:
		$Slot1/Label.text = "빈 슬롯"
		
	if SaveFile.is_file_there(2):
		$Slot2/Label2.text = "Level : " + str(SaveFile._player_data["player_level"]) + "\n" + "Coin : " + str(SaveFile._player_data["coin"])
		$Slot2/delete2.show()
	else:
		$Slot2/Label2.text = "빈 슬롯"
	
	if SaveFile.is_file_there(3):
		$Slot3/Label3.text = "Level : " + str(SaveFile._player_data["player_level"]) + "\n" + "Coin : " + str(SaveFile._player_data["coin"])
		$Slot3/delete3.show()
	else:
		$Slot3/Label3.text = "빈 슬롯"
	
	if SaveFile.is_file_there(4):
		$Slot4/Label4.text = "Level : " + str(SaveFile._player_data["player_level"]) + "\n" + "Coin : " + str(SaveFile._player_data["coin"])
		$Slot4/delete4.show()
	else:
		$Slot4/Label4.text = "빈 슬롯"
	
	if SaveFile.is_file_there(5):
		$Slot5/Label5.text = "Level : " + str(SaveFile._player_data["player_level"]) + "\n" + "Coin : " + str(SaveFile._player_data["coin"])
		$Slot5/delete5.show()
	else:
		$Slot5/Label5.text = "빈 슬롯"
	
	if SaveFile.is_file_there(6):
		$Slot6/Label6.text = "Level : " + str(SaveFile._player_data["player_level"]) + "\n" + "Coin : " + str(SaveFile._player_data["coin"])
		$Slot6/delete6.show()
	else:
		$Slot6/Label6.text = "빈 슬롯"

func saveslot(slot_num):
	Global.player.save_def()
	Global.player_wand.save_def()
	SaveFile.save_file(slot_num)
	SaveFile.load_file(slot_num)
	Global.player.load_def()
	Global.player_wand.load_def()

func _on_SaveSlot1_pressed():
	saveslot(1)
	$Slot1/Label.text = "Level : " + str(SaveFile._player_data["player_level"])
	

func _on_SaveSlot2_pressed():
	saveslot(2)
	$Slot2/Label2.text = "Level : " + str(SaveFile._player_data["player_level"])
	
func _on_SaveSlot3_pressed():
	saveslot(3)
	$Slot3/Label3.text = "Level : " + str(SaveFile._player_data["player_level"])

func _on_SaveSlot4_pressed():
	saveslot(4)
	$Slot4/Label4.text = "Level : " + str(SaveFile._player_data["player_level"])

func _on_SaveSlot5_pressed():
	saveslot(5)
	$Slot5/Label5.text = "Level : " + str(SaveFile._player_data["player_level"])

func _on_SaveSlot6_pressed():
	saveslot(6)
	$Slot6/Label6.text = "Level : " + str(SaveFile._player_data["player_level"])


func _on_OK_pressed():
	queue_free()


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
