extends Node2D

onready var sprite = $Sprite

var placable_items := {
	"나무 궤짝": preload("res://object/Chest.tscn")
}

func _input(event):
	if event is InputEventMouseButton:
		if PlayerInventory.place_obj == true:
			set_process(true)
			sprite.show()
			if event.button_index == BUTTON_LEFT && event.pressed:
				try_place_item(PlayerInventory.place_name)
				sprite.texture = load("res://graphics/objects/" + PlayerInventory.place_name + ".png")
				
func _process(_delta):
	sprite.global_position = get_global_mouse_position()
		
func try_place_item(item_name: String, pos := get_global_mouse_position()):
	if is_instance_valid(Global.object_YSort):
		if not placable_items.has(item_name):
			return
		
		if PlayerInventory.place_slot != null:
			var slot = PlayerInventory.place_slot
			for item in PlayerInventory.inventory:
				if not PlayerInventory.inventory[item].has(item_name):
					PlayerInventory.inventory[slot.slot_index][1] -= 1
					slot.item.decrease_item_quantity(1)
					PlayerInventory.update_slot_visual(slot.slot_index, PlayerInventory.inventory[slot.slot_index][0], PlayerInventory.inventory[slot.slot_index][1])
					slot.refresh_style()
					if PlayerInventory.inventory[slot.slot_index][1] == 0:
						PlayerInventory.remove_item(slot)
						
						
			for item in PlayerInventory.hotbar:
				if PlayerInventory.hotbar[item].has(item_name):
					PlayerInventory.hotbar[slot.slot_index][1] -= 1
					slot.item.decrease_item_quantity(1)
					PlayerInventory.update_slot_visual(slot.slot_index, PlayerInventory.hotbar[slot.slot_index][0], PlayerInventory.hotbar[slot.slot_index][1])
					slot.refresh_style()
					if PlayerInventory.hotbar[slot.slot_index][1] == 0:
						PlayerInventory.remove_item(slot)
						get_node("../../../CanvasLayer/UI/HotBar").initialize_hotbar()

		
		var new_obj = placable_items[item_name].instance()
		new_obj.global_position = pos.snapped(Vector2(64, 64))
		Global.object_YSort.add_child(new_obj)
		PlayerInventory.place_obj = false
		set_process(false)
		sprite.hide()
		new_obj = null
			
	
		
	
