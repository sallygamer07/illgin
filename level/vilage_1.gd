extends vilage

func _ready():
	player = $YSort/Player
	
	player.switch_weapon()
	
	$Main.play()
