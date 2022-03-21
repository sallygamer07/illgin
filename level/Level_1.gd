extends Level

func _ready():
	
	Global.node_creation_parent = self
	player = $YSort/Player
	mobs = $YSort/Mobs
	
	player.switch_weapon()
	
	$Main.play()
