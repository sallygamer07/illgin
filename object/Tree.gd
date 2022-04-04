extends StaticBody2D
class_name tree

onready var area : Area2D = get_node("Object/Area2D")
onready var wooden = preload("res://object/Wooden.tscn")
onready var anim : AnimationPlayer = get_node("AnimationPlayer")
onready var audio : AudioStreamPlayer = get_node("AudioStreamPlayer")

var knockback_direction = Vector2.ZERO
var knockback_force = 0

var max_crash_num = 3
var crash_num = 0

func _ready():
	var _tree_connect = area.connect("area_entered", self, "on_area_entered")
	
func _process(_delta):
	if crash_num == max_crash_num:
		var loot_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
		loot_randomizer.randomize()
		for _i in range(loot_randomizer.randi_range(1, 3)):
			var wooden_ins = wooden.instance()
			get_parent().add_child(wooden_ins)
			wooden_ins.global_position = global_position
		self.queue_free()
	
func on_area_entered(_area):
	if _area.is_in_group("PlayerWeapon"):
		crash_num += 1
		audio.play()
		anim.play("Shake")
	
