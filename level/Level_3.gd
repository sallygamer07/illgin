extends Level

onready var Grass = preload("res://object/Swaying_Grass.tscn")
onready var grass_sort = $YSort/Grass
onready var tileMap = $Navigation2D/Floor

var rng = RandomNumberGenerator.new()

func _ready():
	Global.node_creation_parent = self
	
	#place_patch(Vector2(100, 100), Vector2(2000, 2000))
	
	player.switch_weapon()
	
	$Main.play()
	
	var wgrass = tileMap.get_used_cells_by_id(8)
	var _bgrass = tileMap.get_used_cells_by_id(33)
	
	add_grass(wgrass)
	
func add_grass(array):
	var pos
	for i in range(0, array.size() - 1):
		pos = tileMap.map_to_world(array[i])
		rng.randomize()
		var x = pos.x + rng.randi_range(-5, 5)
		var y = pos.y + rng.randi_range(-5, 5)
		place_grass(x, y)
		
func place_grass(x: int, y: int) -> void:
	var grass = Grass.instance()
	#grass.position = Vector2(x + rand_range(-30.0, 30.0), y + rand_range(-10.0, 10.0))
	grass.position = Vector2(x, y)
	grass.get_node("Grown").material = grass.get_node("Grown").material.duplicate()
	grass.get_node("Grown").material.set_shader_param("offset", float(x * y))
	grass_sort.add_child(grass)

#func place_patch(from: Vector2, to: Vector2) -> void:
#	for x in range(from.x, to.x):
#		if x % 40 != 0:
#			continue
#		for y in range(from.y, to.y):
#			if y % 10 != 0:
#				continue
#			place_grass(x, y)

