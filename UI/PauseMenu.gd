extends Control

var savescene = preload("res://UI/SaveScene.tscn")

var is_paused = false setget set_is_paused

func _ready():
	self.is_paused = false
	

func _unhandled_input(event):
	if event.is_action_pressed("esc"):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused


func _on_Resume_pressed():
	self.is_paused = false
	

func _on_MainMenu_pressed():
	self.is_paused = false
	Global.mainMenu = true
	get_parent().get_parent().get_parent().get_node("Main").stop()
	$FadeScene.transition()


func _on_SaveGame_pressed():
	var scene_ins = savescene.instance()
	add_child(scene_ins)
	scene_ins.show()


func _on_settingsBtn_pressed():
	$Settings.show()


func _on_FadeScene_transitioned():
	SceneChanger.goto_scene("res://UI/Mainmenu.tscn", get_parent().get_parent().get_parent())
