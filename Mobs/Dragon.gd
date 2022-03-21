extends KinematicBody2D

#field boss

export(int) var WANDER_TARGET_RANGE = 32

onready var anim = $AnimationTree
onready var wanderController = $WanderController
onready var playerDetectionZone = $PlayerDetectionZone

var dragonBall = preload("res://Mobs/DragonFireEffect.tscn")
var loot_drop = preload("res://Mobs/Loot_Drop_Boss.tscn")
var floating_text = preload("res://UI/FloatingText.tscn")
var field_boss_RDG = preload("res://Mobs/FieldBossRDG.tscn")


var can_dragonBall = true

var dragonBall_rate = 1.5
var deg_for_dragonBall

var player


var speed = 50
var fri = 200
var acc = 300

var max_health = 600
var health = 0
var died_exp = 300
var dragonBall_ap = 25

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var attack_order = {
	0 : Vector2.UP,
	1 : Vector2.DOWN,
	2 : Vector2.LEFT,
	3 : Vector2.RIGHT,
	4 : Vector2(-1, -1), #북서쪽
	5 : Vector2(1, -1), #북동쪽
	6 : Vector2(-1, 1), #남서쪽
	7 : Vector2(1, 1) #남동쪽
}

enum {
	IDLE,
	WANDER,
	CHASE
}

enum attack_st {
	NORMAL,
	HARD,
	SPREAD
}

var state = IDLE
var attack_state = attack_st.NORMAL

func _ready():
	Global.field_boss = self
	health = max_health
	$ProgressBar.max_value = max_health
	$ProgressBar/Label.set_text(str(health) + "/" + str(max_health))
	
	if Global.field_boss_defeat == true:
		Global.field_boss = null
		self.queue_free()
	
	
func _physics_process(_delta):
	$ProgressBar.value = health
	$ProgressBar/Label.text = str(health) + "/" + str(max_health)
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
			$Sprite.flip_h = velocity.x > 0
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
			
		CHASE:
			player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, _delta)
				anim["parameters/playback"].travel("Attack")
			else:
				state = IDLE
			$Sprite.flip_h = velocity.x > 0

	velocity = move_and_slide(velocity)
		
	if health <= 0:
		Global.player.gain_exp(died_exp)
		self.hide()
		var loot_drop_instance = loot_drop.instance()
		get_parent().add_child(loot_drop_instance)
		loot_drop_instance.position = self.position
		Global.field_boss = null
		Global.field_boss_defeat = true
		var field_boss_RDG_instance = field_boss_RDG.instance()
		get_tree().get_root().add_child(field_boss_RDG_instance)
		self.queue_free()
		

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * speed, acc * delta)
	$Sprite.flip_h = velocity.x > 0

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))
	
func Attack():
	if player != null:
		attack_state = pick_random_state([attack_st.NORMAL, attack_st.HARD, attack_st.SPREAD])
		var target_pos : Vector2 = position
		deg_for_dragonBall = target_pos.angle_to_point(global_position)
		look_at(target_pos)
		
		match attack_state:
			attack_st.NORMAL:
				if can_dragonBall:
					var dragonBall_instance = dragonBall.instance()
					dragonBall_instance.player = player
					dragonBall_instance.position = position
					dragonBall_instance.rotation_degrees = rotation_degrees
					get_tree().get_root().add_child(dragonBall_instance)
					can_dragonBall = false
					$Timer.start(dragonBall_rate)
					yield($Timer, "timeout")
					can_dragonBall = true
					
			attack_st.HARD:
				if can_dragonBall:
					var dragonBall_instance = dragonBall.instance()
					dragonBall_instance.position.x = player.position.x
					dragonBall_instance.position.y = player.position.y - 300
					for _i in range(4):
						var new_dragonBall_instance = dragonBall_instance.duplicate(8)
						var num = int(rand_range(-50, 50))
						var num_y = int(rand_range(500, 800))
						new_dragonBall_instance.position.x = player.position.x + num
						new_dragonBall_instance.position.y = player.position.y - num_y
						get_tree().get_root().add_child(new_dragonBall_instance)
					
					get_tree().get_root().add_child(dragonBall_instance)
					can_dragonBall = false
					$Timer.start(dragonBall_rate)
					yield($Timer, "timeout")
					can_dragonBall = true
					
			attack_st.SPREAD:
				if can_dragonBall:
					for _i in attack_order:
						var dragonBall_instance = dragonBall.instance()
						dragonBall_instance.player = player
						dragonBall_instance.position = position
						dragonBall_instance.rotation_degrees = rotation_degrees
						dragonBall_instance.look_vec = attack_order[_i]
						get_tree().get_root().add_child(dragonBall_instance)
					can_dragonBall = false
					$Timer.start(dragonBall_rate)
					yield($Timer, "timeout")
					can_dragonBall = true

func on_hit():
	health -= Global.player.base_damage
	$BlinkAnimationPlayer.play("start")
	var text = floating_text.instance()
	text.amount = Global.player.base_damage
	text.type = "Damage"
	add_child(text)


func _on_Dragon_Area_area_entered(area):
	if area.is_in_group("Fire"):
		on_hit()
		
	if area.is_in_group("Metaeo"):
		on_hit()
		
	if area.is_in_group("Light_Metaeo"):
		on_hit()
		
	if area.is_in_group("PlayerWeapon"):
		knockback = area.knockback_direction * area.knockback_force
		on_hit()
		
	if area.is_in_group("Arrow"):
		on_hit()

func _on_Dragon_Area_area_exited(area):
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
		



