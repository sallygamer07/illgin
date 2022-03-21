extends StaticBody2D

onready var loot_drop = preload("res://object/Loot_Drop_Flower.tscn")
var collide = false


func _process(_delta):
	if Input.is_action_pressed("interect"):
		delete()

func delete():
	if collide == true:
		self.hide()
		var loot_drop_instance = loot_drop.instance()
		get_parent().add_child(loot_drop_instance)
		loot_drop_instance.position = self.position
		self.queue_free()

func _on_Collider_body_entered(body):
	if body.is_in_group("player"):
		collide = true


func _on_Collider_body_exited(body):
	if body.is_in_group("player"):
		collide = false
