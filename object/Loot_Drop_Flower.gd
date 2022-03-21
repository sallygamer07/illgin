extends Position2D

onready var flower = preload("res://object/Flower.tscn")

var random

func _ready():
	_drop_loot_tier_1()

func _drop_loot_tier_1():
	var loot_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
	loot_randomizer.randomize()
	var loot_percent : int = loot_randomizer.randi_range(0, 100)
	
	if loot_percent >= 0:
		for _i in range(loot_randomizer.randi_range(1, 2)):
			var flower_instance = flower.instance()
			add_child(flower_instance)

