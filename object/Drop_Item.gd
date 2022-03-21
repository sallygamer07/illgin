extends RigidBody2D
class_name drop_item

var impulse_randomizer : RandomNumberGenerator = RandomNumberGenerator.new()
export(String) var item_name

func _ready():

	self.mode = RigidBody2D.MODE_RIGID
	$AnimationPlayer.play("float")
	impulse_randomizer.randomize()
	var impulse : Vector2 = Vector2(impulse_randomizer.randi_range(-10, 10), impulse_randomizer.randi_range(-150, -180))
	self.apply_impulse(self.position, impulse)
	var timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(3)
	timer.start()
	timer.connect("timeout", self, "on_timeout")
	
func on_timeout():
	self.mode = RigidBody2D.MODE_STATIC
	
func _on_timeout():
	if PlayerInventory.add_item(item_name, 1) != false:
		self.queue_free()
	else:
		self.show()
		PlayerInventory.add_item(item_name, -1)
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		$AudioStreamPlayer.play()
		self.hide()
		if self.has_node("CollisionShape2D"):
			$CollisionShape2D.queue_free()
			var timer_ = Timer.new()
			timer_.set_wait_time(0.35)
			add_child(timer_)
			timer_.start()
			timer_.connect("timeout", self, "_on_timeout")
		
