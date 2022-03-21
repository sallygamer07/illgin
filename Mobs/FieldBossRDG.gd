extends Timer

var time
var real_time

func _ready():
	real_time = OS.get_time()
	time = real_time["hour"] + int(rand_range(1, 3)) * 60.0 * 60.0
	#time = real_time["hour"] + int(rand_range(1, 3))
	self.start(time)
	print(time)
	var _time_connect = connect("timeout", self, "on_FielfBossRDG_timeout")
	
	
func on_FielfBossRDG_timeout():
	self.stop()
	Global.field_boss_defeat = false
	Global.player.save_def()
	var dragon = load("res://Mobs/Dragon.tscn")
	var dragon_instance = dragon.instance()
	get_node("/root/Level_2/YSort/Mobs").add_child(dragon_instance)
	dragon_instance.position = Vector2(-657, -998)
	
	print("done")
	self.queue_free()
	
