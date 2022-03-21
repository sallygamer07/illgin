extends Area2D

func _ready():
	set_visible(false)

func _on_Swaying_Grass_body_entered(_body: KinematicBody2D) -> void:
	$Grown.visible = false
	$Growing.frame = 0
	$Growing.play("Growing")
	$Growing.visible = true

func _on_Growing_animation_finished() -> void:
	$Grown.visible = true
	$Growing.visible = false


func _on_VisibilityNotifier2D_screen_entered():
	set_visible(true)


func _on_VisibilityNotifier2D_screen_exited():
	set_visible(false)
