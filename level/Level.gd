extends Node2D
class_name Level

export(Array) var spawn_range_x = [-640, 1408]
export(Array) var spawn_range_y = [-384, 960]

export(String) var level_name = ""

onready var navigation = get_node("Navigation2D")
onready var mobs = get_node("YSort/Mobs")
onready var player = get_node("YSort/Player")


var enemy_1 = preload("res://Mobs/LPS.tscn")
var enemy_2 = preload("res://Mobs/Duggie.tscn")
var dog = preload("res://Mobs/Dog.tscn")


var num


func _ready():
	Global.node_creation_parent = self
	Global.player.data["level"] = name
	Global.mainMenu = false

	
	if Global.from_level != null:
		Global.player.set_position(get_node(Global.from_level + "Pos").global_position)
	
	var dog_instance = dog.instance()
	mobs.add_child(dog_instance)
	dog_instance.global_position = player.global_position
	
func _exit_tree():
	Global.node_creation_parent = null


func _process(_delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), GlobalSettings.music_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), GlobalSettings.fx_volume)
	
	if Global.player != null:
		if Global.player.health <= 20:
			$Main.set_pitch_scale(0.5)
			
		elif Global.player.health >= 21:
			$Main.set_pitch_scale(1.0)
		


func _on_EnemySpawnTimer_timeout():
	var enemy_position = Vector2(rand_range(spawn_range_x[0], spawn_range_x[1]), rand_range(spawn_range_y[0], spawn_range_x[1]))

	while enemy_position.x < spawn_range_x[0] and enemy_position.x > spawn_range_x[1] or enemy_position.y < spawn_range_y[0] and enemy_position.y > spawn_range_y[1]:
		enemy_position = Vector2(rand_range(spawn_range_x[0], spawn_range_x[1]), rand_range(spawn_range_y[0], spawn_range_y[1]))

	num = int(rand_range(1, 3))
	print(num)
	
	if num == 1:
		Global.instance_node(enemy_1, enemy_position, mobs)
	elif num == 2:
		Global.instance_node(enemy_2, enemy_position, mobs)
