extends Node2D
class_name Bow

onready var floating_text = preload("res://UI/FloatingText.tscn")

onready var arrow = preload("res://Weapons/Arrow.tscn")

var deg_for_arrow
var bow_ap = 7
var attack_timer
var bow_rate = 1.2


func _ready():
	Global.player_bow = self
	attack_timer = get_tree().create_timer(0.0)

func set_damage_bow(skill_ap):
	if skill_ap != null:
		Global.player.base_damage = Global.player.current_weapon.base_damage + (Global.player.strength / 2) * (skill_ap / 4)
		print(str(Global.player.base_damage) + "Bow")
		return Global.player.base_damage

func _process(_delta):
	look_at(get_global_mouse_position())
#	print(skill_1A, skill_1B, skill_2A, skill_2B, skill_2C)
	
	if Input.is_action_pressed("attack"):
		var _timer = Timer.new()
		_timer.wait_time = bow_rate
		_timer.one_shot = true
		add_child(_timer)
		_timer.start()
		_timer.connect("timeout", self, "Attack")

func Attack():
	if Global.player_weapon == "Bow":
		var mouse_pos : Vector2 = get_global_mouse_position()
		deg_for_arrow = mouse_pos.angle_to_point(global_position)
		look_at(mouse_pos)
		

		if attack_timer.time_left <= 0.0:
			set_damage_bow(bow_ap)
			var arrow_instance = arrow.instance()
			arrow_instance.position.x = Global.player.position.x
			arrow_instance.position.y = Global.player.position.y
			arrow_instance.rotation_degrees = rotation_degrees
			get_tree().get_root().add_child(arrow_instance)
			attack_timer = get_tree().create_timer(bow_rate)
			yield(attack_timer, "timeout")
