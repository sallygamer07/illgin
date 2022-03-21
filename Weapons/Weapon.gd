extends Node2D
class_name Weapon, "res://graphics/objects/평범한 검.png"

onready var anim : AnimationPlayer = get_node("AnimationPlayer")
onready var hitbox : Area2D = get_node("Node2D/Sprite/HitBox")

var base_damage : int

func _ready():
	if hitbox != null:
		base_damage = hitbox.damage
		hitbox.collision_shape.disabled = true

func get_input() -> void:
	if Input.is_action_pressed("attack") and not anim.is_playing():
		Global.player.attacking = true
		anim.play("Attack")
		if Global.player_weapon == "Sword":
			set_damage_weapon()
		
func move(mouse_dir: Vector2) -> void:
	if not anim.is_playing():
		rotation = mouse_dir.angle()
		hitbox.knockback_direction = mouse_dir
		if scale.y == 1 and mouse_dir.x < 0:
			scale.y = -1
		elif scale.y == -1 and mouse_dir.x > 0:
			scale.y = 1

	
func is_busy() -> bool:
	if anim.is_playing():
		return true
	return false
	
func set_damage_weapon():
	Global.player.base_damage = base_damage + (Global.player.strength / 4)
	print(str(Global.player.base_damage) + "Weapon")
	return Global.player.base_damage

