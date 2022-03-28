extends Position2D


onready var coin = preload("res://object/Coin.tscn")
onready var low_HealthPotion = preload("res://object/low_HealthPotion.tscn")
onready var low_ManaPotion = preload("res://object/low_ManaPotion.tscn")
onready var normal_sword = preload("res://object/NormalSword.tscn")
onready var arrow = preload("res://object/Arrow_item.tscn")

var random

func _ready():
	_drop_loot_tier_1()
	_drop_loot_tier_2()
	_drop_loot_tier_3()
	_drop_loot_tier_4()
	_drop_loot_tier_5()

func _drop_loot_tier_1():
	var loot_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
	loot_randomizer.randomize()
	var loot_percent : int = loot_randomizer.randi_range(1, 100)
	
	if loot_percent >= 0:
		for _i in range(loot_randomizer.randi_range(4, 12)):
			var coin_instance = coin.instance()
			add_child(coin_instance)
			
func _drop_loot_tier_2():
	var loot_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
	loot_randomizer.randomize()
	var loot_percent : int = loot_randomizer.randi_range(1, 100)
	
	if loot_percent >= 0:
		for _i in range(loot_randomizer.randi_range(3, 6)):
			var low_HealthPotion_instance = low_HealthPotion.instance()
			add_child(low_HealthPotion_instance)
			
func _drop_loot_tier_3():
	var loot_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
	loot_randomizer.randomize()
	var loot_percent : int = loot_randomizer.randi_range(1, 100)
	
	if loot_percent >= 0:
		for _i in range(loot_randomizer.randi_range(3, 6)):
			var low_ManaPotion_instance = low_ManaPotion.instance()
			add_child(low_ManaPotion_instance)
			
func _drop_loot_tier_4():
	var loot_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
	loot_randomizer.randomize()
	var loot_percent : int = loot_randomizer.randi_range(0, 200)
	
	if loot_percent >= 0:
		for _i in range(1):
			var normal_sword_instance = normal_sword.instance()
			add_child(normal_sword_instance)
			
func _drop_loot_tier_5():
	var loot_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
	loot_randomizer.randomize()
	var loot_percent : int = loot_randomizer.randi_range(0, 50)
	
	if loot_percent >= 0:
		for _i in range(loot_randomizer.randi_range(3, 8)):
			var arrow_instance = arrow.instance()
			add_child(arrow_instance)

