extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amp = 0
var pri = 0

onready var camera = get_parent()

func start(_dur = 0.2, _fre = 15, _amp = 16, _pri = 0):
	if _pri >= self.pri:
		self.pri = _pri	
		self.amp = _amp
		$Dur.wait_time = _dur
		$Fre.wait_time = 1 / float(_fre)
		$Dur.start()
		$Fre.start()
		
		new_shake()
		

func new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amp, amp)
	rand.y = rand_range(-amp, amp)
	
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, rand, $Fre.wait_time, TRANS, EASE)
	$ShakeTween.start()
	
func reset():
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, Vector2(), $Fre.wait_time, TRANS, EASE)
	$ShakeTween.start()
	pri = 0


func _on_Fre_timeout():
	new_shake()


func _on_Dur_timeout():
	reset()
	$Fre.stop()
