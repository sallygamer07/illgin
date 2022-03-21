extends Control

onready var skillPointLabel = get_node("Skilltree/1/SkillPoint")

func _ready():
	for button in get_tree().get_nodes_in_group("SkillButtons"):
		button.connect("pressed", self, "SpendSkillPoint", [button.get_parent().get_name()])

	skillPointLabel.set_text(str(Global.player.skill_point) + "\n Points")
	$PlayerLevel.set_text(str(Global.player.player_level) + " 레벨")
	
	LoadSkill()
	
func _process(_delta):
	if Global.player != null:
		skillPointLabel.text = (str(Global.player.skill_point) + "\n Points")
		$PlayerLevel.text = (str(Global.player.player_level) + " 레벨")


func LoadSkill():
	for skill in get_tree().get_nodes_in_group("Skills"):
		if Global.player_wand.get("skill_" + skill.get_name()) == true:
			get_node("Skilltree/" + skill.get_name().left(1) + 
			"/" + skill.get_name() + "/TextureButton").set_disabled(false)
			
		elif Global.player_wand.get("skill_" + JsonData.skill_data[skill.get_name()].UnlockSkill) == true:
			if Global.player.player_level >= JsonData.skill_data[skill.get_name()].ReqPlayerLevel:
				var texture_button = get_node("Skilltree/" + skill.get_name().left(1) + "/"
				+ skill.get_name() + "/TextureButton")
				texture_button.set_disabled(false)
				texture_button.set_modulate(Color(0.4, 0.4, 0.4, 1))
				
				
	for connector in get_tree().get_nodes_in_group("SkillConnectors"):
		if Global.player_wand.get("skill_" + connector.get_name()) == true:
			connector.value = 100
		elif Global.player_wand.get("skill_" + JsonData.skill_data[connector.get_name()].UnlockSkill) == true:
			if Global.player.player_level >= JsonData.skill_data[connector.get_name()].ReqPlayerLevel:
				connector.value = 50
				
	
func SpendSkillPoint(skill):
	if Global.player_wand.get("skill_" + skill) == true:
		pass
	else:
		if Global.player.skill_point < JsonData.skill_data[skill].Cost:
			pass
		else:
			var unlocking_skill = JsonData.skill_data[skill].UnlockSkill
			var connector_swimlane = str(unlocking_skill.left(1) + "to" + skill.left(1))
			var tween1 = get_node("SkillsConnector/" + connector_swimlane + "/"
			+ unlocking_skill + "/" + skill + "/Tween")
			var tween2 = get_node("Skilltree/" + skill.left(1) + "/" + skill + "/TextureRect/Tween")
			tween1.interpolate_property(tween1.get_parent(), 'value', 50, 75, 1, Tween.TRANS_QUART, Tween.EASE_OUT)
			tween2.interpolate_property(tween2.get_parent(), 'rect_scale', Vector2(1, 1), Vector2(2.2, 2.2), 0.3, Tween.TRANS_QUART, Tween.EASE_OUT, 0.7)
			tween2.interpolate_property(tween2.get_parent(), 'rect_scale', Vector2(2.2, 2.2), Vector2(1, 1), 0.3, Tween.TRANS_QUART, Tween.EASE_IN, 1)
			tween1.start()
			tween2.start()
			yield(get_tree().create_timer(1.3), "timeout")
			var texture_button = get_node("Skilltree/" + skill.left(1) + "/" + skill + "/TextureButton")
			texture_button.set_modulate(Color(1, 1, 1, 1))
			var skill_name = "skill_" + skill
			Global.player.data[skill_name] = true
			Global.player.skill_point -= JsonData.skill_data[skill].Cost
			skillPointLabel.set_text(str(Global.player.skill_point) + "\n Points")
			


			var unlocking_skills = []
			for key in JsonData.skill_data.keys():
				if JsonData.skill_data[key].UnlockSkill == skill:
					if Global.player.player_level >= JsonData.skill_data[key].ReqPlayerLevel:
						unlocking_skills.append(key)
						connector_swimlane = str(skill.left(1) + "to" + key.left(1))
						var tween = get_node("SkillsConnector/" + connector_swimlane + "/" + skill
						 + "/" + key + "/Tween")
						tween.interpolate_property(tween.get_parent(), 'value', 25, 50, 1, Tween.TRANS_QUART, Tween.EASE_OUT)
						tween.start()
						
			if not unlocking_skills == []:
				yield(get_tree().create_timer(1), "timeout")
				for key in unlocking_skills:
					texture_button = get_node("Skilltree/" + key.left(1) + "/" + key + "/TextureButton")
					texture_button.set_disabled(false)
					texture_button.set_modulate(Color(0.4, 0.4, 0.4, 1))

		
