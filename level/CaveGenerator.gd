extends Node

export(int) var map_width = 80
export(int) var map_height = 50
export(String) var world_seed = "Hi"
export(int) var noise_octaves = 3
export(int) var noise_period = 3
export(float) var noise_pers = 0.7
export(float) var noise_lac = 0.4
export(float) var noise_thr = 0.5
export(bool) var redraw setget _redraw

export(Array) var spawn_range_x = [-640, 1408]
export(Array) var spawn_range_y = [-384, 960]

var enemy_1 = preload("res://Mobs/LPS.tscn")
var enemy_2 = preload("res://Mobs/Duggie.tscn")

var mobs

var num

var tile_map : TileMap
var simplex_noise : OpenSimplexNoise = OpenSimplexNoise.new()

func _ready():
	self.tile_map = get_parent() as TileMap
	mobs = get_node("../../../YSort/Mobs/")
	tile_clear()
	generate()

func _redraw(_value = null) -> void:
	if tile_map == null:
		return
	tile_clear()
	generate()

func tile_clear() -> void:
	tile_map.clear()

func generate() -> void:
	simplex_noise.seed = world_seed.hash()
	simplex_noise.octaves = noise_octaves
	simplex_noise.period = noise_period
	simplex_noise.persistence = noise_pers
	simplex_noise.lacunarity = noise_lac

	for x in range(-map_width / 2, map_width / 2):
		for y in range(-map_height / 2, map_height / 2):
			if simplex_noise.get_noise_2d(x, y) < noise_thr:
				set_autotile(x, y)
	tile_map.update_dirty_quadrants()

func set_autotile(x : int, y : int) -> void:
	tile_map.set_cell(x, y, tile_map.get_tileset().get_tiles_ids()[0], false, false, false, tile_map.get_cell_autotile_coord(x, y))
	tile_map.update_bitmask_area(Vector2(x, y))

	

func _on_Timer_timeout():
	var enemy_position = Vector2(rand_range(spawn_range_x[0], spawn_range_x[1]), rand_range(spawn_range_y[0], spawn_range_x[1]))
	print(enemy_position)
	if tile_map.get_cell(enemy_position.x, enemy_position.y) != -1:

		while enemy_position.x < spawn_range_x[0] and enemy_position.x > spawn_range_x[1] or enemy_position.y < spawn_range_y[0] and enemy_position.y > spawn_range_y[1]:
			enemy_position = Vector2(rand_range(spawn_range_x[0], spawn_range_x[1]), rand_range(spawn_range_y[0], spawn_range_y[1]))

	num = int(rand_range(1, 3))
	print(num)
	
	if num == 1:
		Global.instance_node(enemy_1, enemy_position, mobs)
	elif num == 2:
		Global.instance_node(enemy_2, enemy_position, mobs)
