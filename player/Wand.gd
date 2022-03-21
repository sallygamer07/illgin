extends Node2D

var floating_text = preload("res://UI/FloatingText.tscn")

var fire = preload("res://player/Flame.tscn")
var heal = preload("res://player/Heal.tscn")
var metaeo = preload("res://player/metaeo.tscn")
var light_metaeo = preload("res://player/Light_Metaeo.tscn")
var aura = preload("res://player/Aura.tscn")
var range_ = preload("res://player/Range.tscn")
var range_instance

var skill_1A
var skill_1B
var skill_2A
var skill_2B
var skill_2C
var skill_3A

var fire_rate = 0.2
var heal_rate = 0.5
var metaeo_rate = 8.0
var light_metaeo_rate = 6.0
var aura_rate = 1.5
var deg_for_fire : float
var deg_for_metaeo : float
var deg_for_light_metaeo : float

var mana_empty = false

var fire_ap
var heal_ap
var metaeo_ap
var light_metaeo_ap
var aura_ap
var bling_ap

var attack_timer

var deg_for_wand


func _ready():
	Global.player_wand = self
	if SaveFile.is_file_there(Global.loaded):
		get_parent().data = SaveFile._player_data
	load_def()
	attack_timer = get_tree().create_timer(0.0)
	
func load_def():
	skill_1A = get_parent().data["skill_1A"]
	skill_1B = get_parent().data["skill_1B"]
	skill_2A = get_parent().data["skill_2A"]
	skill_2B = get_parent().data["skill_2B"]
	skill_2C = get_parent().data["skill_2C"]
	skill_3A = get_parent().data["skill_3A"]
	fire_ap = get_parent().data["flame_ap"]
	heal_ap = get_parent().data["heal_ap"]
	metaeo_ap = get_parent().data["metaeo_ap"]
	light_metaeo_ap = get_parent().data["light_metaeo_ap"]
	aura_ap = get_parent().data["aura_ap"]
	bling_ap = get_parent().data["blingbling_ap"]
	
func save_def():
	get_parent().data["skill_1A"] = skill_1A
	get_parent().data["skill_1B"] = skill_1B
	get_parent().data["skill_2A"] = skill_2A
	get_parent().data["skill_2B"] = skill_2B
	get_parent().data["skill_2C"] = skill_2C
	get_parent().data["skill_3A"] = skill_3A
	get_parent().data["flame_ap"] = fire_ap
	get_parent().data["heal_ap"] = heal_ap
	get_parent().data["metaeo_ap"] = metaeo_ap
	get_parent().data["light_metaeo_ap"] = light_metaeo_ap
	get_parent().data["aura_ap"] = aura_ap
	get_parent().data["blingbling_ap"] = bling_ap

func set_damage_wand(skill_ap):
	if skill_ap != null:
		Global.player.base_damage = Global.player.current_weapon.base_damage + (Global.player.strength / 2) * (skill_ap / 4)
		print(str(Global.player.base_damage) + "Wand")
		return Global.player.base_damage

func _process(_delta):
	look_at(get_global_mouse_position())
#	print(skill_1A, skill_1B, skill_2A, skill_2B, skill_2C)

	if skill_2A == true && Global.magic == "Metaeo":
		if get_node_or_null("/root/Range"):
			range_instance = $"/root/Range"
			range_instance.show()
			range_instance.position = get_global_mouse_position()
		else:
			range_instance = range_.instance()
			get_tree().get_root().add_child(range_instance)
	
	elif skill_2B == true && Global.magic == "Light_Metaeo":
		if get_node_or_null("/root/Range"):
			range_instance = $"/root/Range"
			range_instance.show()
			range_instance.position = get_global_mouse_position()
		else:
			range_instance = range_.instance()
			get_tree().get_root().add_child(range_instance)	
	
	else:
		if get_node_or_null("/root/Range"):
			$"/root/Range".hide()
	
	if Input.is_action_pressed("attack"):
		Attack()
		
	if Global.player != null:
		
		if Global.player.mana < 1 and Global.magic == "Fire":
			mana_empty = true
		if Global.player.mana < 2 and Global.magic == "Heal":
			mana_empty = true
		if Global.player.mana < 5 and Global.magic == "Metaeo":
			mana_empty = true
		if Global.player.mana < 4 and Global.magic == "Light_Metaeo":
			mana_empty = true
		if Global.player.mana < 7 and Global.magic == "Aura":
			mana_empty = true

func Attack():
	if Global.player_weapon == "Magic":
		Fire()
		Heal()
		Metaeo()
		Light_Metaeo()
		Aura()
			

func Fire():
	if Global.magic == "Fire":
		var mouse_pos : Vector2 = get_global_mouse_position()
		deg_for_fire = mouse_pos.angle_to_point(global_position)
		look_at(mouse_pos)
		

		if Global.player.mana > 1 and skill_1A == true:
			if attack_timer.time_left <= 0.0:
				set_damage_wand(fire_ap)
				mana_empty = false
				var fire_instance = fire.instance()
				fire_instance.position = Global.player.position
				get_tree().get_root().add_child(fire_instance)
				Global.player.mana -= 2
				skill_1A = false
				attack_timer = get_tree().create_timer(fire_rate)
				yield(attack_timer, "timeout")
				skill_1A = true
			
func Heal():
	if Global.magic == "Heal":
		if Global.player.mana > 2 and skill_1B == true:
			if attack_timer.time_left <= 0.0:
				mana_empty = false
				var heal_instance = heal.instance()
				heal_instance.position = get_parent().position
				get_tree().get_root().add_child(heal_instance)
				if int(Global.player.health) < int(Global.player.max_health):
					Global.player.health += heal_ap
					var text = floating_text.instance()
					text.amount = heal_ap
					text.type = "Heal"
					add_child(text)
				Global.player.mana -= 3
				skill_1B = false
				attack_timer = get_tree().create_timer(heal_rate)
				yield(attack_timer, "timeout")
				skill_1B = true
			
			
func Metaeo():
	if Global.magic == "Metaeo":
		var mouse_pos : Vector2 = get_global_mouse_position()
		deg_for_metaeo = mouse_pos.angle_to_point(global_position)
		look_at(mouse_pos)
		

		if Global.player.mana > 5 and skill_2A == true:
			if attack_timer.time_left <= 0.0:
				set_damage_wand(metaeo_ap)
				mana_empty = false
				var metaeo_instance = metaeo.instance()
				metaeo_instance.position.x = range_instance.position.x
				metaeo_instance.position.y = range_instance.position.y - 500
				get_tree().get_root().add_child(metaeo_instance)
				Global.player.mana -= 6
				skill_2A = false
				attack_timer = get_tree().create_timer(metaeo_rate)
				yield(attack_timer, "timeout")
				skill_2A = true
			
			
func Light_Metaeo():
	if Global.magic == "Light_Metaeo":
		var mouse_pos : Vector2 = get_global_mouse_position()
		deg_for_light_metaeo = mouse_pos.angle_to_point(global_position)
		look_at(mouse_pos)
		

		if Global.player.mana > 4 and skill_2B == true:
			if attack_timer.time_left <= 0.0:
				set_damage_wand(light_metaeo_ap)
				mana_empty = false
				var light_metaeo_instance = light_metaeo.instance()
				light_metaeo_instance.position.x = range_instance.position.x
				light_metaeo_instance.position.y = range_instance.position.y - 500
				for _i in range(4):
					var new_light_metaeo_instance = light_metaeo_instance.duplicate(8)
					var num = int(rand_range(-50, 50))
					var num_y = int(rand_range(500, 800))
					new_light_metaeo_instance.position.x = range_instance.position.x + num
					new_light_metaeo_instance.position.y = range_instance.position.y - num_y
					get_tree().get_root().add_child(new_light_metaeo_instance)
				
				get_tree().get_root().add_child(light_metaeo_instance)
				Global.player.mana -= 5
				skill_2B = false
				attack_timer = get_tree().create_timer(light_metaeo_rate)
				yield(attack_timer, "timeout")
				skill_2B = true


func Aura():
	if Global.magic == "Aura":
		if Global.player.mana > 7 and skill_2C == true:
			if attack_timer.time_left <= 0.0:
				mana_empty = false
				var aura_instance = aura.instance()
				aura_instance.position = get_parent().position
				get_tree().get_root().add_child(aura_instance)
				if int(Global.player.health) < int(Global.player.max_health):
					Global.player.health += aura_ap
					var text = floating_text.instance()
					text.amount = aura_ap
					text.type = "Heal"
					add_child(text)
				Global.player.mana -= 8
				skill_2C = false
				attack_timer = get_tree().create_timer(aura_rate)
				yield(attack_timer, "timeout")
				skill_2C = true
