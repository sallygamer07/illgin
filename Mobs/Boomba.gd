extends KinematicBody2D

#Boss

export(int) var WANDER_TARGET_RANGE = 32

onready var anim = $AnimationTree
onready var wanderController = $WanderController
onready var playerDetectionZone = $PlayerDetectionZone

var swing = preload("res://Mobs/SwingEffect.tscn")
var thunder = preload("res://Mobs/ThunderEffect.tscn")
var loot_drop = preload("res://Mobs/Loot_Drop.tscn")
var floating_text = preload("res://UI/FloatingText.tscn")

var can_swing = true
var can_thunder = true

var swing_rate = 1.0
var thunder_rate = 1.5


var speed = 50
var fri = 200
var acc = 300

var max_health = 1000
var health = 0
var died_exp = 500
var swing_ap = 40
var thunder_ap = 100

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var num = 0

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

func _ready():
	health = max_health
	Global.boss = self
	$ProgressBar.max_value = max_health
	$ProgressBar/Label.set_text(str(health) + "/" + str(max_health))
	
func _physics_process(_delta):
	$ProgressBar.value = health
	$ProgressBar/Label.text = str(health) + "/" + str(max_health)
	knockback = knockback.move_toward(Vector2.ZERO, fri * _delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, fri * _delta)
			anim["parameters/playback"].travel("idle")
			
			if wanderController.get_time_left() == 0:
				update_wander()
			seek_player()
				

		WANDER:
			anim["parameters/playback"].travel("walk")

			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, _delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				anim["parameters/playback"].travel("attack")
				Attack(player)
			else:
				state = IDLE

	velocity = move_and_slide(velocity)
		
	
	if num == 0:
		Global.boss_skill = "Swing"
	elif num == 1:
		Global.boss_skill = "Thunder"
		
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
	
func Attack(_target_):
	
	if Global.boss_skill == "Swing":

		if can_swing:
			var swing_instance = swing.instance()
			swing_instance.position = _target_.position
			get_tree().get_root().add_child(swing_instance)
			can_swing = false
			yield(get_tree().create_timer(swing_rate), "timeout")
			can_swing = true
			num = 1
	
	elif Global.boss_skill == "Thunder":
		
		if can_thunder == true:
			var thunder_instance = thunder.instance()
			thunder_instance.position = _target_.position
			get_tree().get_root().add_child(thunder_instance)
			can_thunder = false
			yield(get_tree().create_timer(thunder_rate), "timeout")
			can_thunder = true
			num = 0

func on_hit():
	health -= Global.player.base_damage
	$BlinkAnimationPlayer.play("start")
	var text = floating_text.instance()
	text.amount = Global.player.base_damage
	text.type = "Damage"
	add_child(text)


func _on_Boss_Area_area_entered(area):
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

func _on_Boss_Area_area_exited(area):
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



