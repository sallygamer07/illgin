extends Node

export var max_load_time = 10000




func goto_scene(path, current_scene):
	var loader = ResourceLoader.load_interactive(path)
	
	if loader == null:
		print("ERROR")
		return
	
	var loading_bar = load("res://UI/LoadingBar.tscn").instance()
	
	get_tree().get_root().add_child(loading_bar)
	
	var t = OS.get_ticks_msec()
	
	while OS.get_ticks_msec() - t < max_load_time:
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			var resource = loader.get_resource()
			get_tree().get_root().call_deferred("add_child", resource.instance())
			get_tree().get_root().remove_child(current_scene)
			current_scene.queue_free()
			loading_bar.queue_free()
			break
		elif err == OK:
			var progress = float(loader.get_stage()) / loader.get_stage_count()
			loading_bar.bar.value = progress * 100
		else:
			print("응답없다 이 새꺄 작작 용량 처먹었어야지")
			break
			
		yield(get_tree(), "idle_frame")
