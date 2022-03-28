extends Control

onready var node_stat_points = get_node("HBoxContainer/VBoxContainer/Stats/MainStats/StatsPoint/Label")
var path_main_stats = "HBoxContainer/VBoxContainer/Stats/MainStats/"

var available_points
var strength_add = 0
var agility_add = 0
var intellect_add = 0
var wisdom_add = 0
var constitution_add = 0
var dexterity_add = 0

func _ready():
	Load_stat()
	
	set_stat_point_label()
	if Global.player.stat_point == 0:
		pass
	else:
		for button in get_tree().get_nodes_in_group("PlusButtons"):
			button.set_disabled(false)
	for button in get_tree().get_nodes_in_group("PlusButtons"):
		button.connect("pressed", self, "IncreaseStat", [button.get_node("../..").get_name()])
	for button in get_tree().get_nodes_in_group("MinButtons"):
		button.connect("pressed", self, "DecreaseStat", [button.get_node("../..").get_name()])
		
	if Global.player != null:
		Global.player.connect("player_level_up", self, "set_stat_point_label")

func _process(_delta):
	if Global.player != null:
		$HBoxContainer/VBoxContainer/Stats/DerivedStats/VBoxContainer/HP/Value.text = str(Global.player.max_health)
		$HBoxContainer/VBoxContainer/Stats/DerivedStats/VBoxContainer/Mana/Value.text = str(Global.player.max_mana)


func set_stat_point_label():
	node_stat_points.set_text("포인트 : " + str(Global.player.stat_point))

func Load_stat():
	get_node(path_main_stats + "Strength/StatBg/Stats/Value").set_text(str(Global.player.strength))
	get_node(path_main_stats + "Agility/StatBg/Stats/Value").set_text(str(Global.player.agility))
	get_node(path_main_stats + "Intellect/StatBg/Stats/Value").set_text(str(Global.player.intellect))
	get_node(path_main_stats + "Wisdom/StatBg/Stats/Value").set_text(str(Global.player.wisdom))
	get_node(path_main_stats + "Constitution/StatBg/Stats/Value").set_text(str(Global.player.constitution))
	get_node(path_main_stats + "Dexterity/StatBg/Stats/Value").set_text(str(Global.player.dexterity))


func IncreaseStat(stat):
	set(stat.to_lower() + "_add", get(stat.to_lower() + "_add") + 1)
	get_node(path_main_stats + stat + "/StatBg/Stats/Change").set_text("+" + str(get(stat.to_lower() + "_add")) + " ")
	get_node(path_main_stats + stat + "/StatBg/Min").set_disabled(false)
	Global.player.stat_point -= 1
	node_stat_points.set_text("포인트 : " + str(Global.player.stat_point))
	if Global.player.stat_point == 0:
		for button in get_tree().get_nodes_in_group("PlusButtons"):
			button.set_disabled(true)
	
func DecreaseStat(stat):
	set(stat.to_lower() + "_add", get(stat.to_lower() + "_add") - 1)
	if get(stat.to_lower() + "_add") == 0:
		get_node(path_main_stats + stat + "/StatBg/Min").set_disabled(true)
		get_node(path_main_stats + stat + "/StatBg/Stats/Change").set_text("")
	else:
		get_node(path_main_stats + stat + "/StatBg/Stats/Change").set_text("+" + str(get(stat.to_lower() + "_add")) + " ")
		
	Global.player.stat_point += 1
	node_stat_points.set_text("포인트 : " + str(Global.player.stat_point))
	for button in get_tree().get_nodes_in_group("PlusButtons"):
		button.set_disabled(false)


func _on_Confirm_pressed():
	if strength_add + agility_add + intellect_add + wisdom_add + constitution_add + dexterity_add == 0:
		print("바뀐게 없어")
	else:
		Global.player.strength += strength_add
		Global.player.agility += agility_add
		Global.player.intellect += intellect_add
		Global.player.wisdom += wisdom_add
		Global.player.constitution += constitution_add
		Global.player.dexterity += dexterity_add
		strength_add = 0
		agility_add = 0
		intellect_add = 0
		wisdom_add = 0
		constitution_add = 0
		dexterity_add = 0
		if Global.player != null:
			Global.player.set_speed()
			Global.player.set_max_mana()
			Global.player.set_max_health()
		Load_stat()
		for button in get_tree().get_nodes_in_group("MinButtons"):
			button.set_disabled(true)
		for label in get_tree().get_nodes_in_group("ChangeLabels"):
			label.set_text("")
		
