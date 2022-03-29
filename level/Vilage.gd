extends Node2D
class_name vilage

export(String) var level_name = ""

onready var ysort = get_node("YSort")
onready var player = get_node("YSort/Player")

var dog = preload("res://Mobs/Dog.tscn")

#onready var mobs = $YSort/Mobs

#var enemy_1 = preload("res://Mobs/LPS.tscn")
#
#var main_audio = preload("res://audio/snowforest.ogg")

func _ready():
	Global.node_creation_parent = self
	Global.player.data["level"] = name
	Global.mainMenu = false
	
#	if player != null:
#		player.global_position = Global.player_pos
	
	if Global.from_level != null:
		Global.player.set_position(get_node(Global.from_level + "Pos").global_position)
	
	var dog_instance = dog.instance()
	ysort.add_child(dog_instance)
	dog_instance.global_position = player.global_position
	
func _exit_tree():
	Global.node_creation_parent = null


func _process(_delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), GlobalSettings.music_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), GlobalSettings.fx_volume)
	
	if Global.player.health <= 20:
		$Main.set_pitch_scale(0.5)
		
	elif Global.player.health >= 21:
		$Main.set_pitch_scale(0.95)


#func _on_EnemySpawnTimer_timeout():
#	var enemy_position = Vector2(rand_range(-640, 1408), rand_range(-384, 960))
#
#	while enemy_position.x < 700 and enemy_position.x > -320 or enemy_position.y < 540 and enemy_position.y > -164:
#		enemy_position = Vector2(rand_range(-640, 1408), rand_range(-384, 960))
#
#	Global.instance_node(enemy_1, enemy_position, mobs)
