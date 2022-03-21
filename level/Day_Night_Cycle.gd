extends CanvasModulate

enum {
	DAY,
	NIGHT
}

var state = DAY

func _ready():
	Global.DayNightCycle = self

func day() -> void:
	state = DAY
	
func night() -> void:
	state = NIGHT

func _process(_delta):
	var time = OS.get_time()
	var TimeInSeconds = time.hour * 3600 + time.minute * 60 + time.second
	var CurrentFrame = range_lerp(TimeInSeconds, 0, 86400, 0, 24)
	$AnimationPlayer.play("DayNightCycle")
	$AnimationPlayer.seek(CurrentFrame)

