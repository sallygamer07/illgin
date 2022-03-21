extends Area2D

export var sceneToMove = ""

onready var anim = $AnimationPlayer


func _ready():
	anim.play("idle")
	
#func _process(_delta):
#	if Global.field_boss != null:
#		hide()
#	else:
#		show()
	

func _on_Portal_toVilage_body_entered(body):
	if body.is_in_group("player"):
		var audio = AudioStreamPlayer.new()
		audio.stream = load("res://audio/portal.wav")
		add_child(audio)
		audio.play()
		anim.play("close")
		Global.player.hide()
		audio.connect("finished", self, "on_finished")

func on_finished():
	Global.from_level = get_parent().get_parent().get_parent().name
	Global.player.save_def()
	SaveFile.save_file(0)
	Global.loaded = 0
	get_parent().get_parent().get_parent().get_node("Main").stop()
	$FadeScene.transition()

func _on_FadeScene_transitioned():
	SceneChanger.goto_scene(sceneToMove, get_parent().get_parent().get_parent())
