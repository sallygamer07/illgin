extends Node
class_name inside

export(String) var outside_path = ""
export(String) var level_name = ""

onready var area : Area2D = get_node("../Area2D")
onready var player : KinematicBody2D = get_node("../YSort/Player")
onready var FadeScene : CanvasLayer = get_node("../FadeScene")
onready var main : AudioStreamPlayer = get_node("../Main")

var entered = false

func _ready():
	
	Global.player.data["level"] = get_parent().name
	Global.node_creation_parent = self
	Global.mainMenu = false
	
	if Global.from_level != null:
		Global.player.set_position(get_node("../" + Global.from_level + "Pos").global_position)
	
	var _inside_area = area.connect("body_entered", self, "on_Area2D_body_entered")
	var _inside_area_ = area.connect("body_exited", self, "on_Area2D_body_exited")
	
func _exit_tree():
	Global.node_creation_parent = null


func _process(_delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), GlobalSettings.music_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), GlobalSettings.fx_volume)
	
	if Global.player != null:
		if Global.player.health <= 20:
			main.set_pitch_scale(0.5)
			
		elif Global.player.health >= 21:
			main.set_pitch_scale(1.0)
			
	if entered:
		exit()
	
func on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		entered = true
		
func on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		entered = false
			
func exit():
	Global.player.save_def()
	SaveFile.save_file(0)
	Global.loaded = 0
	get_node("../Main").stop()
	FadeScene.transition()


func _on_FadeScene_transitioned():
	Global.from_level = get_parent().name
	SceneChanger.goto_scene(outside_path, get_parent())
