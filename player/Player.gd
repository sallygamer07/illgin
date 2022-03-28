extends KinematicBody2D
class_name Player

signal player_damaged
signal player_level_up
signal player_die

const FRICTION : float = 0.15

export(int) var acc = 40
export(int) var max_speed = 100

onready var anim = $AnimationPlayer
onready var timer = $ManaUpdate
onready var blink_anim = $BlinkAnimationPlayer
onready var animated_sprite : AnimatedSprite = get_node("AnimatedSprite")
onready var weapons : Node2D = get_node("Weapons")
onready var floating_text = preload("res://UI/FloatingText.tscn")
onready var field_boss_RDG = preload("res://Mobs/FieldBossRDG.tscn")
onready var ghost_scene = preload("res://player/DashGhost.tscn")
onready var mobile_controls = preload("res://UI/MobileControls.tscn")
onready var blink_material = preload("res://Player_Blink.tres")
onready var dissolve_material = preload("res://DissolveShader.tres")
onready var fade = preload("res://UI/FadeScene.tscn")



var current_weapon : Node2D

var dir = Vector2.ZERO
var vel = Vector2.ZERO

var speed = 0
var default_health = 100
var max_health
var health
var default_mana = 20
var max_mana
var mana
var player_exp
var player_exp_total
var player_exp_required
var player_level
var coin
var skill_point

var strength
var agility
var intellect
var wisdom
var constitution
var dexterity

var stat_point

var base_damage

var attacking = false
var mana_update = 1.0
var timer_reset = false

var player_dead = false

var can_hurt = true
var hurt_rate = 0.05
var hurt_timer

var is_dashing = false
var can_dash = true
var dash_delay = 0.4

var is_sitting = false

var house = null setget set_house
var sitArea = null setget set_sitArea


enum states {
	IDLE,
	WALK,
	HURT,
	SIT
}

var state = states.IDLE

var data = {
		"max_health" : 100,
		"health" : 100,
		"max_mana" : 20,
		"mana" : 20,
		"strength" : 5,
		"agility" : 5,
		"intellect" : 5,
		"wisdom" : 5,
		"constitution" : 5,
		"dexterity" : 5,
		"skill_1A" : true,
		"flame_ap" : 10,
		"skill_1B" : true,
		"heal_ap" : 3,
		"skill_2A" : false,
		"metaeo_ap" : 18,
		"skill_2B" : false,
		"light_metaeo_ap" : 13,
		"skill_2C" : false,
		"aura_ap" : 6, 
		"skill_3A" : false,
		"blingbling_ap" : 30,
		"x" : 1128,
		"y" : 1376,
		"level" : "Level_1",
		"player_level" : 1,
		"exp" : 0,
		"exp_total" : 0,
		"coin" : 1000000,
		"skill_point" : 0,
		"stat_point" : 5,
		"quests" : {},
		"inventory" : PlayerInventory.inventory,
		"hotbar" : PlayerInventory.hotbar,
		"field_boss_defeat" : false
	}

func _ready() -> void:
	Global.player = self
	animated_sprite.material = blink_material
	animated_sprite.material.set_shader_param("active", false)
	if SaveFile.is_file_there(Global.loaded):
		SaveFile.load_file(Global.loaded)
		data = SaveFile._player_data
	load_def()
	player_exp_required = get_required_exp(player_level + 1)
	
	current_weapon = weapons.get_child(0)
	
	if not (
			Dialogs.connect("dialog_started", self, "_on_dialog_started") == OK and
			Dialogs.connect("dialog_ended", self, "_on_dialog_ended") == OK ):
		printerr("Error connecting to dialog system")
		
	hurt_timer = get_tree().create_timer(0.0)
	
	set_speed()
	set_max_mana()
	set_max_health()
	
	if Global.loaded == -1:
		PlayerInventory.inventory = {}
		PlayerInventory.hotbar = {}
		health = max_health
		mana = max_mana
		
	set_house(null)
	set_sitArea(null)
	

	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		var controls_instance = mobile_controls.instance()
		add_child(controls_instance)
		controls_instance.connect("use_move_vector", self, "_on_MobileControls_use_move_vector")
	
	var _die_connect = connect("player_die", self, "on_player_die")
	
	
func set_house(new_house):
	house = new_house
	
func set_sitArea(new_sitArea):
	sitArea = new_sitArea
	
func set_speed():
	speed = max_speed + agility * 4
	
func set_max_mana():
	max_mana = default_mana + intellect * 4
	
func set_max_health():
	max_health = default_health + constitution * 4
	

func load_def():
	health = data["health"]
	mana = data["mana"]
	max_health = data["max_health"]
	max_mana = data["max_mana"]
	player_exp = data["exp"]
	player_exp_total = data["exp_total"]
	player_level = data["player_level"]
	coin = data["coin"]
	skill_point = data["skill_point"]
	stat_point = data["stat_point"]
	strength = data["strength"]
	agility = data["agility"]
	intellect = data["intellect"]
	wisdom = data["wisdom"]
	constitution = data["constitution"]
	dexterity = data["dexterity"]
	Quest.quest_list = data["quests"]
	PlayerInventory.inventory = data["inventory"]
	PlayerInventory.hotbar = data["hotbar"]
	position.x = data["x"]
	position.y = data["y"]
	Global.field_boss_defeat = data["field_boss_defeat"]
	
	
func save_def():
	data["health"] = health
	data["mana"] = mana
	data["max_health"] = max_health
	data["max_mana"] = max_mana
	data["x"] = position.x
	data["y"] = position.y
	data["level"] = get_parent().get_parent().name
	data["player_level"] = player_level
	data["exp"] = player_exp
	data["exp_total"] = player_exp_total
	data["coin"] = coin
	data["skill_point"] = skill_point
	data["inventory"] = PlayerInventory.inventory
	data["hotbar"] = PlayerInventory.hotbar
	data["quests"] = Quest.quest_list
	data["strength"] = strength
	data["agility"] = agility
	data["wisdom"] = wisdom
	data["intellect"] = intellect
	data["constitution"] = constitution
	data["dexterity"] = dexterity
	data["field_boss_defeat"] = Global.field_boss_defeat
	data["stat_point"] = stat_point


func _physics_process(_delta):
	if OS.get_name() == "Windows" or OS.get_name() == "OSX" or OS.get_name() == "HTML5" or OS.get_name() == "X11":
		player_pc_process(_delta)
	elif OS.get_name() == "Android" or OS.get_name() == "iOS":
		player_mobile_process(_delta)
	
func player_pc_process(_delta : float):
	#print(SaveFile._player_data["level"], data["level"])
	if Global.active == false or Global.active_shop == false:
		if is_sitting == false:
			vel = move_and_slide(vel, dir, false)
			for index in get_slide_count():
				var collision = get_slide_collision(index)
				var collider = collision.collider
				var remainder = collision.remainder
				
				if collider != null:
					if collider is WoodenBox:
						collider.move_and_collide(remainder) # move block by remainder

						
			vel = lerp(vel, Vector2.ZERO, FRICTION)
			
			get_input()
			
			if dir == Vector2.ZERO:
				state = states.IDLE

				
			if house != null:
				$interectE.show()
			else:
				$interectE.hide()
				
			if sitArea != null:
				$interectEtoSit.show()
			else:
				$interectEtoSit.hide()
		
	_state()
	
	var mouse_dir : Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	if mouse_dir.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_dir.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true	
		
	if current_weapon != null:
		current_weapon.move(mouse_dir)
		current_weapon.get_input()
		
	if Input.is_action_just_pressed("interect") and sitArea != null:
		var previous_pos : Vector2 = global_position
		if is_sitting == false:
			state = states.SIT
			is_sitting = true
			global_position = sitArea.sitPos.global_position
			$interectEtoSit.text = "[E]키를 눌러 일어서기"

		else:
			state = states.IDLE
			is_sitting = false
			global_position = previous_pos
			$interectEtoSit.text = "[E]키를 눌러 앉기"
			
	if data["level"].find("Inside") == -1:
		$Light2D.enabled = false
	else:
		$Light2D.enabled = true

			
	if player_dead == false:
		if timer_reset == false:
			timer_reset = true
			timer.set_wait_time(mana_update)
			timer.start()
			
	if health <= 0:
		dead_shader()
		
	
func dead_shader():
	animated_sprite.material = dissolve_material
	$DissolveAnimationPlayer.play("dead")
	
	
func get_input() -> void:
	dir = Vector2.ZERO
	if Input.is_action_pressed("up"):
		dir += Vector2.UP
		move()
	if Input.is_action_pressed("down"):
		dir += Vector2.DOWN
		move()
	if Input.is_action_pressed("left"):
		dir += Vector2.LEFT
		move()
	if Input.is_action_pressed("right"):
		dir += Vector2.RIGHT
		move()

	if current_weapon != null:
		current_weapon.get_input()
		
	if Input.is_action_pressed("dash") && is_dashing == false && can_dash:
		dash()
		instance_ghost()
		
	if Input.is_action_just_pressed("interect") and house != null:
		Global.player_pos = global_position
		house.enter()


func dash():
	speed = speed + 300
	animated_sprite.material.set_shader_param("active", true)
	move()
	$dashTimer.start()
	$GhostTimer.start()
	health -= 3
	is_dashing = true
	
	
func instance_ghost():
	var ghost : Sprite = ghost_scene.instance()
	get_parent().add_child(ghost)
	
	ghost.global_position = animated_sprite.global_position
	if self.scale == Vector2(1, 1):
		ghost.scale = animated_sprite.scale
	else:
		ghost.scale = Vector2(2, 2)
	ghost.frame = animated_sprite.frame
	ghost.flip_h = animated_sprite.flip_h
	
func switch_weapon() -> void:
	var slot = get_tree().root.get_node("/root/" + get_parent().get_parent().name + "/CanvasLayer/UI/HotBar/HotBarSlots").get_children()
	var weapon_name = slot[PlayerInventory.active_item_slot].item
	if weapon_name != null:
		var weapon_category = JsonData.item_data[weapon_name.item_name]["ItemCategory"]

		if weapon_category == "Sword":
			if current_weapon != null:
				current_weapon.hide()
			current_weapon = weapons.get_node(weapon_name.item_name)
			Global.player_weapon = "Sword"
			current_weapon.show()
			
		elif weapon_category == "Wand":
			if current_weapon != null:
				current_weapon.hide()
			current_weapon = weapons.get_node(weapon_name.item_name)
			Global.player_weapon = "Magic"
			current_weapon.show()
			
		elif weapon_category == "Bow":
			if current_weapon != null:
				current_weapon.hide()
			current_weapon = weapons.get_node(weapon_name.item_name)
			Global.player_weapon = "Bow"
			current_weapon.show()
			
		else:
			Global.player_weapon = null
			if current_weapon != null:
				current_weapon.hide()
			current_weapon = null
			
	else:
		Global.player_weapon = null
		if current_weapon != null:
			current_weapon.hide()
		current_weapon = null


func move() -> void:
	dir = dir.normalized()
	vel += dir * acc
	vel = vel.clamped(speed)
	state = states.WALK

	
	if $FootStepTimer.time_left <= 0:
		$AudioStreamPlayer.pitch_scale = rand_range(0.8, 1.2)
		$AudioStreamPlayer.play()
		$FootStepTimer.start(0.4)
	
func _state() -> void:
	if state == states.IDLE:
		anim.play("Idle")

	if state == states.WALK:
		anim.play("Walk")
		
	if state == states.SIT:
		anim.play("sit")

func _on_dialog_started():
	pass

func _on_dialog_ended():
	pass



func _health_potion(amount):
	health += amount
	var text = floating_text.instance()
	text.amount = amount
	text.type = "Heal"
	add_child(text)



func get_required_exp(level):
	return round(pow(level, 1.8) + level * 4)
	
func gain_exp(amount):
	player_exp_total += amount
	player_exp += amount
	var growth_data = []
	while player_exp >= player_exp_required:
		player_exp -= player_exp_required
		growth_data.append([player_exp_required, player_exp_required])
		level_up()
	growth_data.append([player_exp, get_required_exp(player_level + 1)])
	
		
func level_up():
	$LevelUP.show()
	player_level += 1
	player_exp_required = get_required_exp(player_level + 1)
	skill_point += 1
	stat_point += 5
	var _timer = Timer.new()
	_timer.set_wait_time(0.7)
	add_child(_timer)
	_timer.start()
	_timer.connect("timeout", self, "on_LevelUP_timeout")
	emit_signal("player_level_up")

	
func on_LevelUP_timeout():
	$LevelUP.hide()
	
	
func _on_ManaUpdate_timeout():
	if mana < max_mana:
		mana += 0.2
		timer.stop()
		timer_reset = false
		
func exited_can_hurt():
	can_hurt = false
	var timer_ = Timer.new()
	add_child(timer_)
	timer_.start(hurt_rate)
	yield(timer_, "timeout")
	can_hurt = true
	
func on_hurt(damage):
	var text = floating_text.instance()
	text.amount = damage
	text.type = "Damage"
	add_child(text)
	
func _on_HurtBox_area_entered(area):
	if area != null:
		if can_hurt == true:
			if area.is_in_group("Swing"):
				health -= int(Global.boss.swing_ap)
				blink_anim.play("Start")
				on_hurt(Global.boss.swing_ap)
				
			if area.is_in_group("Thunder"):
				health -= int(Global.boss.thunder_ap)
				blink_anim.play("Start")
				on_hurt(Global.boss.thunder_ap)
				
			if area.is_in_group("SP"):
				if Global.LPS_wand != null:
					health -= int(Global.LPS_wand.SP_ap)
					blink_anim.play("Start")
					on_hurt(Global.LPS_wand.SP_ap)
				
			if area.is_in_group("DragonBall"):
				health -= int(Global.field_boss.dragonBall_ap)
				blink_anim.play("Start")
				on_hurt(Global.field_boss.dragonBall_ap)
				
			if area.is_in_group("Duggie"):
				health -= int(area.get_parent().ap)
				blink_anim.play("Start")
				on_hurt(area.get_parent().ap)
				
			state = states.HURT


func _on_HurtBox_area_exited(area):
	if area != null:
		if area.is_in_group("Swing"):
			exited_can_hurt()
			blink_anim.play("Stop")
			
		if area.is_in_group("Thunder"):
			exited_can_hurt()
			blink_anim.play("Stop")
			
		if area.is_in_group("SP"):
			exited_can_hurt()
			blink_anim.play("Stop")
			
		if area.is_in_group("DragonBall"):
			exited_can_hurt()
			blink_anim.play("Stop")
			
		if area.is_in_group("Duggie"):
			exited_can_hurt()
			blink_anim.play("Stop")
			
	state = states.IDLE



func _on_dashTimer_timeout():
	$GhostTimer.stop()
	animated_sprite.material.set_shader_param("active", false)
	set_speed()
	can_dash = false
	yield(get_tree().create_timer(dash_delay), "timeout")
	can_dash = true
	is_dashing = false


func _on_GhostTimer_timeout():
	instance_ghost()

func player_mobile_process(_delta : float):
	if Global.active == false or Global.active_shop == false:
		if is_sitting == false:
			move()
			vel = move_and_slide(vel, dir, false)
			
			for index in get_slide_count():
				var collision = get_slide_collision(index)
				var collider = collision.collider
				var remainder = collision.remainder
				
				if collider != null:
					if collider is WoodenBox:
						collider.move_and_collide(remainder) # move block by remainder
			
			vel = lerp(vel, Vector2.ZERO, FRICTION)
			animated_sprite.flip_h = dir.x < 0
				
			if current_weapon != null:
				current_weapon.move(dir)
				current_weapon.get_input()
				
				
			if house != null:
				$interectE.show()
			else:
				$interectE.hide()
				
			#sit null show hide
		
		_state()
				
		if data["level"].find("Inside") == -1:
			$Light2D.enabled = false
		else:
			$Light2D.enabled = true

				
		if player_dead == false:
			if timer_reset == false:
				timer_reset = true
				timer.set_wait_time(mana_update)
				timer.start()
				
		if health <= 0:
			dead_shader()
	
	
func _on_MobileControls_use_move_vector(move_vector):
	dir = move_vector


func on_player_die():
	player_dead = true
	var fade_ins = fade.instance()
	add_child(fade_ins)
	fade_ins.transition()
	fade_ins.connect("transitioned", self, "on_transitioned")
		
func on_transitioned():
	Global.player = null
	queue_free()
	SceneChanger.goto_scene("res://level/GameOver.tscn", get_parent().get_parent())


