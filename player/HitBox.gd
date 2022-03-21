extends Area2D
class_name Hitbox

export(int) var damage: int = 1
var knockback_direction: Vector2 = Vector2.ZERO
export(int) var knockback_force: int = 300

var body_inside: bool = false

onready var collision_shape: CollisionShape2D = get_child(0)
onready var timer: Timer = Timer.new()


