extends Node2D

var direction = Vector2.ZERO

var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var speed = 6
var player = null

var maxtime = 1.2 # adjust this in seconds
var smoketime = 1.0

var collide = false

func _ready():
	hide()
	
	$smoke.playing = false
	
	if Global.field_boss.attack_state == Global.field_boss.attack_st.NORMAL:
		if player != null:
			look_vec = player.position - global_position
		speed = 6
		move = Vector2(speed, 0).rotated(Global.field_boss.deg_for_dragonBall)
		
	elif Global.field_boss.attack_state == Global.field_boss.attack_st.SPREAD:
		speed = 6
		move = Vector2(speed, 0).rotated(Global.field_boss.deg_for_dragonBall)
	
	else:
		speed = 400
		move = Vector2(0, speed)

	var timer = Timer.new()
	timer.wait_time = maxtime
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", self, "on_timeout")
	

func _physics_process(delta):
	if Global.field_boss != null and Global.player != null:
		if Global.field_boss.attack_state == Global.field_boss.attack_st.NORMAL or Global.field_boss.attack_state == Global.field_boss.attack_st.SPREAD:
			if collide == false:
				speed = 6
				move = Vector2.ZERO
				move = move.move_toward(look_vec, delta)
				move = move.normalized() * speed
				position += move


		else:
			if collide == false:
				position += move * delta
				position += direction


func on_timeout():
	self.queue_free()

func _on_Collider_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("Object"):
		collide = true
		$smoke.show()
		$sprite.hide()
		$smoke.playing = true
		var timer = Timer.new()
		timer.wait_time = smoketime
		timer.autostart = true
		add_child(timer)
		timer.connect("timeout", self, "on_timeout")

	elif body.is_in_group("Enemy"):
		$smoke.hide()
		collide = false


func _on_Collider_body_exited(_body):
	collide = false



func _on_Collider_area_entered(_area):
	if _area.is_in_group("PlayerWeapon"):
		collide = true
		$smoke.show()
		$sprite.hide()
		$smoke.playing = true
		var timer = Timer.new()
		timer.wait_time = smoketime
		timer.autostart = true
		add_child(timer)
		timer.connect("timeout", self, "on_timeout")


func _on_Collider_area_exited(_area):
	collide = false
