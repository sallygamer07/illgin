extends StaticBody2D


var speed := 550
var vel : Vector2

var start = Vector2.ZERO
var direction = Vector2.ZERO
var maxtime = 1.0 # adjust this in seconds

var collide = false

func _ready():
	$AnimatedSprite.frame = 0
	#vel = Vector2(speed, 0).rotated(Global.player_wand.deg_for_fire)
	
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


func _on_Collider_body_entered(body):
	if body.is_in_group("Object") or body.is_in_group("player"):
		collide = true
		
	elif body.is_in_group("Enemy"):
		collide = false
	


func _on_Collider_body_exited(_body):
	collide = false
