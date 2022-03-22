extends KinematicBody2D

export var WANDER_TARGET_RANGE = 4

onready var loot_drop = preload("res://Mobs/Loot_Drop.tscn")
onready var floating_text = preload("res://UI/FloatingText.tscn")

onready var anim = $AnimationTree
onready var wanderController = $WanderController
onready var playerDetectionZone = $PlayerDetectionZone
onready var navigation : Navigation2D = get_node("../../..").navigation 

var speed = 80
var fri = 200
var acc = 300

var max_health = 10
var health = 0
var died_exp = 2

var target = null

var ap = 2

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var path : PoolVector2Array

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE

func _ready():
	health = max_health
	state = pick_random_state([IDLE, WANDER])
	
func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, fri * _delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, fri * _delta)
			anim["parameters/playback"].travel("Idle")
			
			if wanderController.get_time_left() == 0:
				update_wander()
			seek_player()
				

		WANDER:
			anim["parameters/playback"].travel("Walk")

			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, _delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
			
		CHASE:
			if Global.player.data["level"].find("Cave") != -1:
				target = playerDetectionZone.player
				if path:
					var vector_to_next_point : Vector2 = path[0] - global_position
					var distance_to_next_point : float = vector_to_next_point.length()
					if distance_to_next_point < 1:
						path.remove(0)
						if not path:
							return
							
					var dir = vector_to_next_point
					anim["parameters/playback"].travel("Walk")
					velocity = velocity.move_toward(dir * speed, acc * _delta)
				else:
					state = IDLE
					
			else:
				var player = playerDetectionZone.player
				if player != null:
					anim["parameters/playback"].travel("Walk")
					var dir = (player.global_position - global_position).normalized()
					velocity = velocity.move_toward(dir * speed, acc * _delta)
				else:
					state = IDLE

	if velocity == Vector2.ZERO:
		anim.get("parameters/playback").travel("Idle")
	else:
		anim.get("parameters/playback").travel("Walk")
		anim.set("parameters/Idle/blend_position", velocity)
		anim.set("parameters/Walk/blend_position", velocity)
	
	velocity = move_and_slide(velocity)
	
	
	if health <= 0:
		Global.player.gain_exp(died_exp)
		self.hide()
		var loot_drop_instance = loot_drop.instance()
		get_parent().add_child(loot_drop_instance)
		loot_drop_instance.position = self.position
		self.queue_free()


func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * speed, acc * delta)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func on_hit():
	if Global.player.base_damage != null:
		health -= Global.player.base_damage
		$BlinkAnimationPlayer.play("start")
		var text = floating_text.instance()
		text.amount = Global.player.base_damage
		text.type = "Damage"
		add_child(text)

func _on_DuggieArea_area_entered(area):
	if area.is_in_group("Fire"):
		health -= Global.player.base_damage
		on_hit()
		
	if area.is_in_group("Metaeo"):
		health -= Global.player_wand.metaeo_ap
		on_hit()
		
	if area.is_in_group("Light_Metaeo"):
		health -= Global.player_wand.metaeo_ap
		on_hit()
		
	if area.is_in_group("PlayerWeapon"):
		knockback = area.knockback_direction * area.knockback_force
		on_hit()
		
	if area.is_in_group("Arrow"):
		on_hit()
		
		

func _on_DuggieArea_area_exited(area):
	if area.is_in_group("Fire"):
		$BlinkAnimationPlayer.play("stop")
		
	if area.is_in_group("Metaeo"):
		$BlinkAnimationPlayer.play("stop")
		
	if area.is_in_group("Light_Metaeo"):
		$BlinkAnimationPlayer.play("stop")
		
	if area.is_in_group("PlayerWeapon"):
		$BlinkAnimationPlayer.play("stop")
		
	if area.is_in_group("Arrow"):
		$BlinkAnimationPlayer.play("stop")


func _on_PathTimer_timeout() -> void:
	if target != null && navigation != null:
		path = navigation.get_simple_path(global_position, target.position)
