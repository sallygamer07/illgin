extends Node2D
class_name Player_Effect

onready var smoke = get_node("smoke")
onready var sprite = get_node("sprite")

export(int) var speed = 550
var vel : Vector2

var direction = Vector2.ZERO
var smoketime = 0.5
var maxtime = 1.0

var collide = false

func _ready():
	hide()
	smoke.playing = false
	
	vel = Vector2(0, speed)

	
func _process(delta: float) -> void:
	if collide == false:
		position += vel * delta
		position += direction
		
func on_timeout():
	self.queue_free()


func _on_Collider_area_entered(area):
	if area.is_in_group("Enemy"):
		collide = true
		smoke.show()
		sprite.hide()
		smoke.playing = true
		var timer = Timer.new()
		timer.wait_time = smoketime
		timer.autostart = true
		add_child(timer)
		timer.connect("timeout", self, "on_timeout")
		
	elif area.is_in_group("player"):
		smoke.hide()
		
	elif area.is_in_group("Range"):
		collide = true
		smoke.show()
		sprite.hide()
		smoke.playing = true
		var timer = Timer.new()
		timer.wait_time = smoketime
		timer.autostart = true
		add_child(timer)
		timer.connect("timeout", self, "on_timeout")


func _on_Collider_area_exited(_area):
	if not _area.is_in_group("Range"):
		collide = false


