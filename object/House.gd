extends Node
class_name house, "res://graphics/objects/houses/house_2.png"

onready var area : Area2D = get_node("../Area2D")

export(String) var inside_path = ""

func _ready():
	var _area = area.connect("body_entered", self, "on_Area2D_body_entered")
	var _area_ = area.connect("body_exited", self, "on_Area2D_body_exited")

	
func on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.house = self
		
func on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		if body.house == self:
			body.house = null
			
func enter():
	Global.from_level = get_parent().get_parent().get_parent().get_parent().name
	Global.player.save_def()
	Global.player_wand.save_def()
	SaveFile.save_file(0)
	SaveFile.load_file(0)
	Global.loaded = 0
	SceneChanger.goto_scene(inside_path, get_parent().get_parent().get_parent().get_parent())
	
