extends Control

#Ingr label tscn
#wooden texture
#minimap icon
#crafting table (object) tscn

func _ready():
	Global.loaded = -1
	$LoadScene.hide()
	Global.mainMenu = true
	Global.node_creation_parent = null
	
func _process(_delta):
	if Global.loaded == -1:
		PlayerInventory.inventory = {}
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), GlobalSettings.music_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), GlobalSettings.fx_volume)

func _on_NewGame_pressed():
	Global.loaded = -1
	Global.from_level = null
	Global.mainMenu = false
	$Main.stop()
	$FadeScene.transition()


func _on_LoadGame_pressed():
	Global.from_level = null
	$LoadScene.show()


func _on_Quit_pressed():
	get_tree().quit()


func _on_Settings_pressed():
	$Settings.show()



func _on_FadeScene_transitioned():
	SceneChanger.goto_scene("res://UI/Intro.tscn", self)


func _on_VisibilityNotifier2D_screen_entered():
	$Main.play()
