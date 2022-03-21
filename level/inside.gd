extends Node
class_name inside

export(String) var outside_path = ""

onready var area : Area2D = get_node("../Area2D")
onready var player : KinematicBody2D = get_node("../YSort/Player")
onready var Pos : Position2D = get_node("../enterPos")
onready var FadeScene : CanvasLayer = get_node("../FadeScene")

var entered = false

func _ready():
	
	Global.player.data["level"] = get_parent().name
	
	
	var _ins_area = area.connect("body_entered", self, "on_Area2D_body_entered")
	var _ins_area_ = area.connect("body_exited", self, "on_Area2D_body_exited")

	player.set_position(Pos.global_position)
	
func on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if entered:
			exit()
		
func on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		entered = true
			
func exit():
	Global.from_level = get_parent().name
	FadeScene.transition()


func _on_FadeScene_transitioned():
	SceneChanger.goto_scene(outside_path, get_parent())
