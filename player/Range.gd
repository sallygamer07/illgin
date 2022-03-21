extends StaticBody2D

onready var sprite = $Sprite
	
func _process(_delta):
	if Global.mainMenu == true:
		queue_free()
