extends Area2D

export var sceneToMove = ""

onready var collisionShape = $CollisionShape2D

func _on_DungeonExit_body_entered(body):
	if body is Player:
		Global.from_level = get_parent().name
		Global.player.save_def()
		SaveFile.save_file(0)
		Global.loaded = 0
		get_node("../Main").stop()
		$FadeScene.transition()


func _on_FadeScene_transitioned():
	SceneChanger.goto_scene(sceneToMove, get_parent().get_parent().get_parent())
