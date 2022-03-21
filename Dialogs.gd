extends Node


signal dialog_started
signal dialog_ended

var active = false

var dialog_box = null setget _set_dialog_box

func show_dialog(text: String, speaker: String):
	if is_instance_valid(dialog_box):
		dialog_box.show_dialog(text, speaker)

func _set_dialog_box(node):
	if not node is Node:
		push_error("provided node doesn't extend Node")
		return
	
	dialog_box = node
	
	if dialog_box.get_script().has_script_signal("dialog_started"):
		dialog_box.connect("dialog_started", self, "_on_dialog_started")
	else:
		push_error("provided node doesn't implement dialog_started signal")
	
	if dialog_box.get_script().has_script_signal("dialog_ended"):
		dialog_box.connect("dialog_ended", self, "_on_dialog_ended")
	else:
		push_error("provided node doesn't implement dialog_started signal")
	
	pass
	
func _on_dialog_started():
	active = true
	emit_signal("dialog_started")
	
func _on_dialog_ended():
	active = false
	emit_signal("dialog_ended")
