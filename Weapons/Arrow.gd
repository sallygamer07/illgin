extends StaticBody2D

var speed := 550

var vel = Vector2()
var direction = Vector2.ZERO

export var life_time = 1.0
export var arrow_damage = 10

var collide = false

func _ready():
	vel = Vector2(speed, 0).rotated(Global.player_bow.deg_for_arrow)
	
	var timer = Timer.new()
	timer.wait_time = life_time
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", self, "on_timeout")
		
func _process(_delta) -> void:
	if collide == false:
		position += vel * _delta
		position += direction

		

func on_timeout():
	self.queue_free()


func _on_Collider_area_entered(area):
	if area.is_in_group("Enemy") or area.is_in_group("Object") or area.is_in_group("NPC"):
		collide = true
#		$smoke.show()
		$sprite.hide()
		#$smoke.playing = true
#		var timer = Timer.new()
#		timer.wait_time = smoketime
#		timer.autostart = true
#		add_child(timer)
#		timer.connect("timeout", self, "on_timeout")
		
	elif area.is_in_group("player"):
		collide = false
#		$smoke.hide()


func _on_Collider_area_exited(_area):
	collide = false


func _on_Collider_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("Object") or body.is_in_group("NPC"):
		collide = true
		#$smoke.show()
		$sprite.hide()
		#$smoke.playing = true
#		var timer = Timer.new()
#		timer.wait_time = smoketime
#		timer.autostart = true
#		add_child(timer)
#		timer.connect("timeout", self, "on_timeout")
#
	elif body.is_in_group("player"):
		collide = false
#		$smoke.hide()


func _on_Collider_body_exited(_body):
	collide = false
