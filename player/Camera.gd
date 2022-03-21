extends Camera2D

onready var topLeft = $Limits/TopLeft
onready var bottomRight = $Limits/BottomRight

onready var player = get_node("../YSort/Player")

func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x
	
	player.connect("player_damaged", self, "on_player_damaged")
	
func _input(event):
	if event.is_action_pressed("plus"):
		if zoom > Vector2(0.1, 0.1):
			zoom = zoom - Vector2(0.05, 0.05)
			
	if event.is_action_pressed("minus"):
		if zoom < Vector2(1, 1):
			zoom = zoom + Vector2(0.05, 0.05)


func _on_Area2D_area_entered(area):
	if area.is_in_group("Metaeo") or area.is_in_group("light_metaeo") or area.is_in_group("DragonBall"):
		area.get_parent().show()
		

func on_player_damaged():
	$ScreenShake.start(0.2, 15, 16, 1)
