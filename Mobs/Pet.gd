extends Node
class_name Pet

enum states {
	IDLE,
	WALK
}

onready var pet = get_parent()
onready var anim = get_parent().get_node("AnimationTree")
onready var player

var go_range = 100
var speed = 200

var state = states.IDLE

func _ready():
	player = Global.player

func _physics_process(_delta):
	if player != null:
		var to_player = player.global_position - pet.global_position
		var distance = to_player.length()
		var direction = Vector2.ZERO
		speed = player.speed
		
		match state:
			states.IDLE:
				direction = Vector2.ZERO
				#anim["parameters/playback"].travel("Idle")
			states.WALK:
				#anim["parameters/playback"].travel("Walk")
				direction = to_player.normalized()

		if distance > go_range:
			state = states.WALK
		else:
			state = states.IDLE
			
		pet.move_and_slide(direction * speed)
		
		if direction == Vector2.ZERO:
			anim.get("parameters/playback").travel("Idle")
		else:
			anim.get("parameters/playback").travel("Walk")
			anim.set("parameters/Idle/blend_position", direction)
			anim.set("parameters/Walk/blend_position", direction)		
