extends Control

var quest_name
var message = "의 퀘스트"

func _ready():
	var _err_ = Quest.connect("get_quest_name", self, "set_quest_name")
	var _e_rr = Quest.connect("quest_ended", self, "on_quest_ended")
	update_questTree()
	
func _process(_delta):
	update_questTree()
	set_player_level()
	
func set_quest_name(_quest_name):
	quest_name = _quest_name
	
func update_questTree():
	if quest_name != null:
		if Quest.quest_list.has(quest_name):
			if has_node("Bg/VBoxContainer/" + quest_name):
				pass
			else:
				var label = Label.new()
				label.name = quest_name
				label.text = quest_name
				$Bg/VBoxContainer.add_child(label)
		else:
			if has_node("Bg/VBoxContainer/" + quest_name):
				var label = get_node("Bg/VBoxContainer/" + quest_name)
				label.queue_free()

func on_quest_ended(quest_name_):
	if not Quest.quest_list.has(quest_name_):
		if has_node("Bg/VBoxContainer/" + quest_name_):
			var label = get_node("Bg/VBoxContainer/" + quest_name_)
			label.queue_free()
			
func set_player_level():
	if Global.node_creation_parent != null:
		$Title.text = Global.node_creation_parent.level_name + message
