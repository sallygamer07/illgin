extends KinematicBody2D

onready var collider = $Collider

var quest_succ = preload("res://graphics/quest_succ.png")
var quest_give = preload("res://graphics/quest_give.png")

var active = false


export(String) var character_name = "차닭"
export(Array, String, MULTILINE) var dialogs = ["..."]
var current_dialog = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	# warning-ignore:return_value_discarded
	collider.connect("body_entered", self, "_on_body_entered")
	# warning-ignore:return_value_discarded
	collider.connect("body_exited", self, "_on_body_exited")

	
func _process(_delta):
	var quest_status = Quest.get_status($Quest.quest_name)
	match quest_status:
		Quest.STATUS.NONEXISTENT:
			$questSprite.set_texture(quest_give)
			$questSpriteAnim.play("idle")
		Quest.STATUS.STARTED:
			var getting_item = PlayerInventory.get_item($Quest.required_item)
			if getting_item != null:
				if getting_item >= $Quest.required_amount:
					$questSprite.set_texture(quest_succ)
					$questSpriteAnim.play("idle")
				else:
					$questSprite.set_texture(quest_give)
		Quest.STATUS.COMPLETE:
			$questSprite.hide()
			$questSpriteAnim.stop()
		Quest.STATUS.FAILED:
			$questSprite.set_texture(quest_give)
			$questSpriteAnim.play("idle")
			

func _input(event):
	if (
			active and not
			dialogs.empty() and
			event.is_action_pressed("interect") and not
			Dialogs.active
		):
		if has_node("Quest"):
			var quest_dialog = get_node("Quest").process()
			if quest_dialog != "":
				Dialogs.show_dialog(quest_dialog, character_name)
				return
		Dialogs.show_dialog(dialogs[current_dialog], character_name)
		current_dialog = wrapi(current_dialog + 1, 0, dialogs.size())

func _on_body_entered(body):
	if body is Player:
		active = true
		
func _on_body_exited(body):
	if body is Player:
		active = false
