extends Control

func _ready():
	hide()
	$Menu/MusicVolum.value = -10
	$Tutorial.hide()
	$Menu/FullScreenBtn.pressed = GlobalSettings.fullscreen

func _on_ok_pressed():
	hide()


func _on_FullScreenBtn_toggled(button_pressed):
	if button_pressed == true:
		GlobalSettings.fullscreen = button_pressed
		OS.window_fullscreen = GlobalSettings.fullscreen
		
	elif button_pressed == false:
		GlobalSettings.fullscreen = button_pressed
		OS.window_fullscreen = GlobalSettings.fullscreen



func _on_MusicVolum_value_changed(value):
	GlobalSettings.music_volume = value


func _on_MusicVolum2_value_changed(value):
	GlobalSettings.fx_volume = value


func _on_tutorialBtn_pressed():
	$Tutorial.show()
