extends KinematicBody2D

onready var loot_drop = preload("res://object/Loot_Drop_Chest.tscn")
onready var anim = $AnimationPlayer

var in_player : bool = false
var is_opened : bool = false

var give_exp

func _ready():
	anim.play("Idle")
	give_exp = int(rand_range(10, 30))
	$Label.hide()

func _process(_delta):
	if Input.is_action_pressed("interect") and in_player and not is_opened:
		is_opened = true
		anim.play("open")
		
func item_drop():
	Global.player.gain_exp(give_exp)
	var loot_drop_instance = loot_drop.instance()
	get_parent().add_child(loot_drop_instance)
	loot_drop_instance.position = self.position
	anim.play("Close")

func _on_InPlayer_body_entered(body):
	if body.is_in_group("player"):
		in_player = true
		$Label.show()

func _on_InPlayer_body_exited(body):
	if body.is_in_group("player"):
		in_player = false
		$Label.hide()
