extends Control


func _ready():
	Global.loaded = -1
	$LoadScene.visible = false
	Global.node_creation_parent = null
	$gameOver.play()


func _on_Restart_pressed():
	Global.loaded = -1
	Global.from_level = null
	Global.mainMenu = false
	var _error = get_tree().change_scene("res://level/Level_1.tscn")


func _on_LoadGame_pressed():
	Global.from_level = null
	$LoadScene.visible = true


func _on_MainMenu_pressed():
	var _err_or = get_tree().change_scene("res://UI/Mainmenu.tscn")
