extends StaticBody2D

onready var area : Area2D = get_node("Object/Area2D")
onready var anim : AnimationPlayer = get_node("AnimationPlayer")
onready var audio : AudioStreamPlayer = get_node("AudioStreamPlayer")
onready var rock = preload("res://object/Stone.tscn")

var crash_num = 0
var max_crash_num = 5

func _ready():
	var _rock_connect = area.connect("area_entered", self, "on_area_entered")
	
func _process(_delta):
	if crash_num == max_crash_num:
		var loot_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
		loot_randomizer.randomize()
		for _i in range(loot_randomizer.randi_range(1, 4)):
			var rock_ins = rock.instance()
			get_parent().add_child(rock_ins)
			rock_ins.global_position = global_position
		self.queue_free()
	
func on_area_entered(_area):
	if _area.is_in_group("PlayerWeapon"):
		audio.play()
		anim.play("Shake")
		crash_num += 1
