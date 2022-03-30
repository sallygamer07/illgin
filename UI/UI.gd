extends Control


onready var charcter_sheet = preload("res://UI/CharacterSheet.tscn")
onready var map = preload("res://UI/Map.tscn")

onready var HPbar = $HealthBar
onready var HPLabel = $HealthBar/Label
onready var MPbar = $ManaBar
onready var MPLabel = $ManaBar/Label
onready var ExpBar = $ExpBar
onready var ExpLabel = $ExpBar/Label
onready var LevelLabel = $PlayerLevel
onready var box = $Box
var player

var holding_item = null
var selecting_item = null

var character_sheet_visible = false
var map_visible = false


func _ready():
	show()
	Global.magic = "Fire"
	initialize(Global.player.player_exp, Global.player.player_exp_required)
	show_skillbar()
	Global.player.set_max_health()
	Global.player.set_max_mana()
	ExpLabel.text = str(Global.player.player_exp) + "/" + str(Global.player.player_exp_required)
	HPLabel.text = str(Global.player.health) + "/" + str(Global.player.max_health)
	HPLabel.text = str(Global.player.mana) + "/" + str(Global.player.max_mana)
	Global.player.connect("player_level_up", self, "initialize", [Global.player.player_exp, Global.player.player_exp_required])
	var _no_slot = PlayerInventory.connect("noEmptySlot", self, "noEmptySlot_label")

func _process(_delta):
	if Global.player != null:
		HPbar.value = int(Global.player.health)
		HPLabel.text = str(Global.player.health) + "/" + str(Global.player.max_health)
		MPLabel.text = str(Global.player.mana) + "/" + str(Global.player.max_mana)
		MPbar.value = int(Global.player.mana)
		
		HPbar.max_value = int(Global.player.max_health)
		MPbar.max_value = int(Global.player.max_mana)
		
		ExpBar.value = Global.player.player_exp
		ExpLabel.text = str(Global.player.player_exp) + "/" + str(Global.player.player_exp_required)
		LevelLabel.text = str(Global.player.player_level) + " 레벨"
	
	
		shop()
		pain()
		set_skill_lock()
		show_skillbar()
		
		if Global.player != null:
			if Global.player.health <= 0:
				self.hide()
		
		
		
	
	
func initialize(current, maximum):
	ExpBar.max_value = maximum
	ExpBar.value = current

	
	
func _input(event):
	if event.is_action_pressed("1"):
		if Global.player_wand.skill_1A == true:
			$Bg.show()
			box.rect_position.x = $Bg.rect_position.x - 5
			Global.magic = "Fire"
		else:
			$Bg.hide()
			
			
	if event.is_action_pressed("2"):
		if Global.player_wand.skill_1B == true:
			$Bg2.show()
			box.rect_position.x = $Bg2.rect_position.x - 5
			Global.magic = "Heal"
		else:
			$Bg2.hide()
			
	if event.is_action_pressed("3"):
		if Global.player_wand.skill_2A == true:
			$Bg3.show()
			box.rect_position.x = $Bg3.rect_position.x - 5
			Global.magic = "Metaeo"
		else:
			$Bg3.hide()
			
	if event.is_action_pressed("4"):
		if Global.player_wand.skill_2B == true:
			$Bg4.show()
			box.rect_position.x = $Bg4.rect_position.x - 5
			Global.magic = "Light_Metaeo"
		else:
			$Bg4.hide()
			
	if event.is_action_pressed("5"):
		if Global.player_wand.skill_2C == true:
			$Bg5.show()
			box.rect_position.x = $Bg5.rect_position.x - 5
			Global.magic = "Aura"
		else:
			$Bg5.hide()
			
	
	if event.is_action_pressed("inventory"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.initialize_inventory()
		
	if Global.player_in_shop == "PotionShop":
		if event.is_action_pressed("interect"):
			Global.active_shop = true
	if Global.player_in_shop == "WeaponShop":
		if event.is_action_pressed("interect"):
			Global.active_shop = true
		
	if Global.player_in_shop == null:
		if event.is_action_pressed("interect"):
			Global.active_shop = false
			
	if event.is_action_pressed("QuestTree"):
		$QuestTree.visible = !$QuestTree.visible
			
	if event.is_action_pressed("skill"):
		$SkillTree.visible = !$SkillTree.visible
		
	if event.is_action_pressed("map"):
		map_visible = !map_visible
		if map_visible == true:
			var map_instance = map.instance()
			add_child(map_instance)
			move_child(map_instance, 20)
		if map_visible == false:
			if get_node_or_null("Map"):
				var m = get_node("Map")
				m.queue_free()
		
	if event.is_action_pressed("CharacterSheet"):
		character_sheet_visible = !character_sheet_visible
		if character_sheet_visible == true:
			var ch_instance = charcter_sheet.instance()
			add_child(ch_instance)
			move_child(ch_instance, 20)
		if character_sheet_visible == false:
			if get_node_or_null("CharacterSheet"):
				var cha = get_node("CharacterSheet")
				cha.queue_free()
		
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_down()
		
	if event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_up()

func set_skill_lock():
	if $Inventory.visible == false or $SkillTree.visible == false or $QuestTree.visible == false or character_sheet_visible == false or $Shops.visible == false or map_visible == false:
		player_unlock()
	if $Inventory.visible == true or $SkillTree.visible == true or $QuestTree.visible == true or character_sheet_visible == true or $Shops.visible == true or map_visible == true:
		player_lock()


func player_lock():
	Global.active = true
	Global.player_wand.skill_1A = false
	Global.player_wand.skill_1B = false
	Global.player_wand.skill_2A = false
	Global.player_wand.skill_2B = false
	Global.player_wand.skill_2C = false
	Global.player_wand.skill_3A = false
	$Box.visible = false
	show_skillbar()
	

func player_unlock():
	Global.active = false
	Global.player_wand.skill_1A = Global.player.data["skill_1A"]
	Global.player_wand.skill_1B = Global.player.data["skill_1B"]
	Global.player_wand.skill_2A = Global.player.data["skill_2A"]
	Global.player_wand.skill_2B = Global.player.data["skill_2B"]
	Global.player_wand.skill_2C = Global.player.data["skill_2C"]
	Global.player_wand.skill_3A = Global.player.data["skill_3A"]
	$Box.visible = true
	show_skillbar()
			

func noEmptySlot_label():
	$NoEmptySlot.show()
	$AlamAuido.play()
	var _timer_ = Timer.new()
	add_child(_timer_)
	_timer_.start(3)
	_timer_.connect("timeout", self, "noEmptySlot_label_timeout", [_timer_])
	
func noEmptySlot_label_timeout(_timer_):
	_timer_.stop()
	$NoEmptySlot.hide()

func pain():
	if Global.player.health <= 20:
		$HurtOverlay.show()
		$HurtOverlay.modulate.a = 0.54
	else:
		$HurtOverlay.hide()
		
func shop():
	if Global.player_in_shop == "PotionShop" and Global.active_shop == true:
		player_lock()
		$Shops.show()
		$Shops/PotionShopUI.show()
		$Shops/WeaponShopUI.hide()
	
	if Global.player_in_shop == "WeaponShop" and Global.active_shop == true:
		player_lock()
		$Shops.show()
		$Shops/WeaponShopUI.show()
		$Shops/PotionShopUI.hide()
	
	if Global.active_shop == false:
		player_unlock()
		$Shops.hide()
		
func show_skillbar():
	$Bg.visible = Global.player_wand.skill_1A
	$Bg2.visible = Global.player_wand.skill_1B
	$Bg3.visible = Global.player_wand.skill_2A
	$Bg4.visible = Global.player_wand.skill_2B
	$Bg5.visible = Global.player_wand.skill_2C


