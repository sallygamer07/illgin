extends Level

func _ready():
	
	Global.node_creation_parent = self
	
	player.switch_weapon()
	
	$Main.play()
