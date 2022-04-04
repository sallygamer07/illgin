extends Node

var player_wand
var player_bow
var player
var player_pos
var magic
var boss
var boss_skill
var field_boss
var field_boss_defeat
var LPS
var LPS_wand

var node_creation_parent

var from_level

var loaded = -1
var mainMenu

var player_in_shop
var active = false
var active_shop = false

var player_weapon

var DayNightCycle

var object_YSort

var crafting_table = false

func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance
