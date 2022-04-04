extends MarginContainer

export var zoom = 1.5 setget set_zoom

onready var grid = $MarginContainer/Grid
onready var player_marker = $MarginContainer/Grid/PlayerMarker
onready var NPC_marker = $MarginContainer/Grid/NPCMarker

onready var icons = {
	"NPC" : NPC_marker
}

var grid_scale
var markers = {}
var player

func _ready():
	player = Global.player
	player_marker.position = grid.rect_size / 2
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
	set_map_objects()
	
	
func set_map_objects():
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for item in map_objects:
		var new_marker = icons[item.minimap_icon].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker
		
			
func _process(_delta):
	if !is_instance_valid(player):
		return
	
	for item in markers:
		var obj_pos = (item.position - player.position) * grid_scale + grid.rect_size / 2
		if grid.get_rect().has_point(obj_pos + grid.rect_position):
			markers[item].scale = Vector2(0.3, 0.3)
		else:
			markers[item].scale = Vector2(0.2, 0.2)
		obj_pos.x = clamp(obj_pos.x, 0, grid.rect_size.x)
		obj_pos.y = clamp(obj_pos.y, 0, grid.rect_size.y)
		markers[item].position = obj_pos
	
func set_zoom(value):
	zoom = clamp(value, 0.5, 5)
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
