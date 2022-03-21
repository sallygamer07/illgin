extends Control

onready var label = $VBoxContainer/RichTextLabel

var _timer

func _ready():
	var _get_connect = PlayerInventory.connect("get_item_label", self, "label_show")
	
func label_show(_item_name) -> void:
	label.bbcode_text += _item_name + " + 1"
	label.bbcode_text += "\n"
	_timer = Timer.new()
	add_child(_timer)
	_timer.start(2)
	_timer.connect("timeout", self, "on_timeout")
	
func on_timeout():
	_timer.stop()
	label.bbcode_text += "\r"
	label.bbcode_text = ""
