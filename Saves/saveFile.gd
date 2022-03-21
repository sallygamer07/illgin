extends Node

const SAVE_DIR = "user://saves/"

var path = SAVE_DIR + "save" + str(slot_num) + ".dat"

var slot_num = 0

var _player_data

var file = File.new()

var dir = Directory.new()


func save_file(num):
	slot_num = num
	path = SAVE_DIR + "save" + str(slot_num) + ".dat"
	var data = Global.player.data
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
		
	
	var _error = file.open(path, File.WRITE)
	file.open(path, File.WRITE)
	file.store_var(data)
	file.close()
	
func load_file(num):
	slot_num = num
	path = SAVE_DIR + "save" + str(slot_num) + ".dat"
	if file.file_exists(path):
		var error = file.open(path, File.READ)
		if error == OK:
			_player_data = file.get_var()
			file.close()

func is_file_there(num):
	slot_num = num
	var b : bool
	path = SAVE_DIR + "save" + str(slot_num) + ".dat"
	if file.file_exists(path):
		b = true
		load_file(num)
		return b
		
func delete_file(num):
	slot_num = num
	path = SAVE_DIR + "save" + str(slot_num) + ".dat"
	if file.file_exists(path):
		dir.remove(path)
