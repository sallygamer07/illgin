extends Position2D

onready var coin = preload("res://object/Coin.tscn")
onready var low_HealthPotion = preload("res://object/low_HealthPotion.tscn")
onready var low_ManaPotion = preload("res://object/low_ManaPotion.tscn")

var random

func _ready():
	_drop_loot_tier_1()
	_randomize_item()

func _drop_loot_tier_1():
	var loot_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
	loot_randomizer.randomize()
	var loot_percent : int = loot_randomizer.randi_range(0, 100)
	
	if loot_percent >= 0:
		for _i in range(loot_randomizer.randi_range(1, 6)):
			var coin_instance = coin.instance()
			add_child(coin_instance)
			
func _drop_loot_tier_2():
	var loot_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
	loot_randomizer.randomize()
	var loot_percent : int = loot_randomizer.randi_range(0, 100)
	
	if loot_percent >= 0:
		for _i in range(loot_randomizer.randi_range(1, 2)):
			var low_HealthPotion_instance = low_HealthPotion.instance()
			add_child(low_HealthPotion_instance)
			
func _drop_loot_tier_3():
	var loot_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
	loot_randomizer.randomize()
	var loot_percent : int = loot_randomizer.randi_range(0, 100)
	
	if loot_percent >= 0:
		for _i in range(loot_randomizer.randi_range(1, 2)):
			var low_ManaPotion_instance = low_ManaPotion.instance()
			add_child(low_ManaPotion_instance)
			
func _randomize_item():
	random = int(rand_range(0, 2))
	
	if random == 1:
		_drop_loot_tier_2()
	elif random == 0:
		_drop_loot_tier_3()
		
