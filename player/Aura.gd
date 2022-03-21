extends StaticBody2D

var maxtime = 0.8

func _ready():
	$AnimatedSprite.frame = 0
	var timer = Timer.new()
	timer.wait_time = maxtime
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", self, "on_timeout")

func on_timeout():
	self.queue_free()
