extends Node2D

onready var tex_rect = $TextureRect
onready var label = $Label

var item_name
var item_quantity

func _ready():
	var rand_val = randi() % 2
	
	if rand_val == 0:
		item_name = "하급 회복 포션"
	elif rand_val == 1:
		item_name = "하급 마나 포션"
		
	tex_rect.texture = load("res://graphics/objects/" + item_name + ".png")
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1
	
	if stack_size == 1:
		label.visible = false
	else:
		label.text = String(item_quantity)

		
func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	tex_rect.texture = load("res://graphics/objects/" + item_name + ".png")
	tex_rect.rect_min_size = Vector2(64, 64)
	tex_rect.rect_size = tex_rect.rect_min_size
	
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		label.visible = false
	else:
		label.visible = true
		label.text = String(item_quantity)
		
	#tex_rect.hint_tooltip = JsonData.item_data[item_name]["Description"]
		
		
func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	label.text = String(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	label.text = String(item_quantity)

