extends Node2D
class_name Objection

onready var player_dectection : Area2D = get_node("Area2D")

export(NodePath) var sprite_path
var sprite

func _ready():
	var _connect = player_dectection.connect("body_entered", self, "on_Area2D_body_entered")
	var _connect_ = player_dectection.connect("body_exited", self, "on_Area2D_body_exited")
	
	sprite = get_node(sprite_path)

	
func on_Area2D_body_entered(area):
	if area.is_in_group("player"):
		if sprite != null:
			sprite.modulate = "#5fffffff"
	
func on_Area2D_body_exited(_area):
	if _area.is_in_group("player"):
		if sprite != null:
			sprite.modulate = "#ffffff"
