extends Position2D

onready var label = $Label
onready var tween = $Tween

var amount = 0
var type = ""

var vel = Vector2(0, 0)
var max_size = Vector2(1, 1)

func _ready():
	label.set_text(str(amount))
	match type:
		"Heal":
			label.set("custom_colors/font_color", Color("2eff27"))
		"Damage":
			label.set("custom_colors/font_color", Color("ff3131"))
		"Critical":
			max_size = Vector2(1.5, 1.5)
			label.set("custom_colors/font_color", Color("ff3131"))
			
	randomize()
	var side_movement = randi() % 41 - 20
	vel = Vector2(side_movement, 50)
	tween.interpolate_property(self, "scale", scale, max_size, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, "scale", max_size, Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
	
	tween.start()

func _process(_delta):
	position -= vel * _delta

func _on_Tween_tween_all_completed():
	self.queue_free()
