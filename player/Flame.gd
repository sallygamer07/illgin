extends StaticBody2D

var speed := 550
var vel : Vector2

var direction = Vector2.ZERO
var maxtime = 1.0 # adjust this in seconds
var smoketime = 0.2

var collide = false

func _ready():
	$sprite.frame = 0
	$smoke.playing = false
	
	vel = Vector2(speed, 0).rotated(Global.player_wand.deg_for_fire)
	
	var timer = Timer.new()
	timer.wait_time = maxtime
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", self, "on_timeout")

	
func _process(delta: float) -> void:
	if collide == false:
		position += vel * delta
		position += direction


func on_timeout():
	self.queue_free()



func _on_Collider_area_entered(area):
	if area.is_in_group("Enemy") or area.is_in_group("Object") or area.is_in_group("NPC"):
		collide = true
		$smoke.show()
		$sprite.hide()
		$smoke.playing = true
		var timer = Timer.new()
		timer.wait_time = smoketime
		timer.autostart = true
		add_child(timer)
		timer.connect("timeout", self, "on_timeout")
		
	elif area.is_in_group("player"):
		$smoke.hide()


func _on_Collider_area_exited(_area):
	collide = false


func _on_Collider_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("Object") or body.is_in_group("NPC"):
		collide = true
		$smoke.show()
		$sprite.hide()
		$smoke.playing = true
		var timer = Timer.new()
		timer.wait_time = smoketime
		timer.autostart = true
		add_child(timer)
		timer.connect("timeout", self, "on_timeout")
		
	elif body.is_in_group("player"):
		$smoke.hide()


func _on_Collider_body_exited(_body):
	collide = false
