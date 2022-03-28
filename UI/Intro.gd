extends Node

onready var texrect = $TextureRect
onready var label = $Label
onready var main = $Main

var intro_path = "res://graphics/intro/"

var dialog = {
	0 : "옛날 옛날에 빨간모자 일진냥이가 살았어요.",
	1 : "일진냥이는 도시락 바구니를 들고 심부름을 가던 중 희끄무레한 무언가를 만났어요.",
	2 : "전봇대처럼 커서 조금 짜증이 났죠.",
	3 : "하얀 생명체는 다짜고짜 초면에 반말을 시전했어요."
}

var dialog_index = 0


func _ready():
	_intro()
	
func _intro():
	for i in range(4):
		var texture = load(intro_path + str(i + 1) + ".png")
		texrect.texture = texture
		label.text = dialog[dialog_index]
		dialog_index += 1
		var time_r = Timer.new()
		add_child(time_r)
		time_r.start(5)
		yield(time_r, "timeout")
		if i == 3:
			_on_FadeScene_transitioned()

func _process(_delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), GlobalSettings.music_volume)


func _on_Skip_pressed():
	main.stop()
	$FadeScene.transition()
	
func _on_FadeScene_transitioned():
	SceneChanger.goto_scene("res://level/Level_1.tscn", self)
