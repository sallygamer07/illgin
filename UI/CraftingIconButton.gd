extends Button

export var NAME = ""


func _on_Button_pressed():
	get_parent().get_parent().Item_pressed(NAME)
