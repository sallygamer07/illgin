extends Node2D
class_name bossArea

onready var fence_collision : CollisionPolygon2D = get_node("Fence/CollisionPolygon2D")


func _ready():
	fence_collision.set_deferred("disabled", true)
	
func _process(_delta):
	if Global.boss.health != null:
		if Global.boss.health <= 0:
			queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		fence_collision.set_deferred("disabled", false)
