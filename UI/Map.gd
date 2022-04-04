extends Control


onready var playerSprite = $PlayerSprite

func _ready():
	for button in get_tree().get_nodes_in_group("LevelBtn"):
		if button.name == Global.player.data["level"]:
			playerSprite.global_position = button.get_node("Sprite").global_position
		else:
			playerSprite.hide()
