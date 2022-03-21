extends Node

var item_data : Dictionary
var skill_data : Dictionary

func _ready():
	item_data = LoadData("res://Data/ItemData.json")
	skill_data = LoadData("res://Data/SkillTreeData.json")
	
func LoadData(filepath):
	var json_data
	var file_data = File.new()
	
	file_data.open(filepath, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	file_data.close()
	return json_data.result
