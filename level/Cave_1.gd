extends Level

onready var CaveGNT = get_node("Navigation2D/Floor/CaveGenerator")
onready var tileMap = get_node("Navigation2D/Floor")


func _ready():
	player = $YSort/Player
	mobs = $YSort/Mobs
	navigation = get_node("Navigation2D")
	
	player.switch_weapon()
	
	$Camera2D.topLeft.position = Vector2(-CaveGNT.map_width, CaveGNT.map_height)
	$Camera2D.bottomRight.position = Vector2(CaveGNT.map_width, -CaveGNT.map_height)


