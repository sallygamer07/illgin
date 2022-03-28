extends Node

signal get_item_label(item_name)
signal noEmptySlot

signal active_item_updated

const SlotClass = preload("res://player/Slot.gd")
const ItemClass = preload("res://player/Item.gd")
const NUM_INVENTORY_SLOTS = 32
const NUM_HOTBAR_SLOTS = 8

var inventory = {}

var hotbar = {}

var active_item_slot = 0


func get_item(item_name : String):
	for item in inventory:
		if inventory[item][0] == item_name:
			return inventory[item][1]
	for item in hotbar:
		if hotbar[item][0] == item_name:
			return hotbar[item][1]


func add_item(item_name : String, item_quantity : int):
	if inventory.size() < NUM_INVENTORY_SLOTS:
		emit_signal("get_item_label", item_name)
		for item in inventory:
			if typeof(inventory[item][0]) == TYPE_STRING:
				if inventory[item][0] == item_name:
					var stack_size = int(JsonData.item_data[item_name]["StackSize"])
					var able_to_add = stack_size - inventory[item][1]
					if able_to_add >= item_quantity:
						inventory[item][1] += item_quantity
						update_slot_visual(item, inventory[item][0], inventory[item][1])
						return true
					else:
						inventory[item][1] += able_to_add
						update_slot_visual(item, inventory[item][0], inventory[item][1])
						item_quantity = item_quantity - able_to_add
						return true
							
				
		for i in range(NUM_INVENTORY_SLOTS):
			if inventory.has(i) == false:
				inventory[i] = [item_name, item_quantity]
				update_slot_visual(i, inventory[i][0], inventory[i][1])
				return
				
	if inventory.size() >= NUM_INVENTORY_SLOTS:
		#print("NOPE")
		#print(inventory.size())
		emit_signal("noEmptySlot")
		return false
			
func update_slot_visual(slot_index : int, item_name, new_quantity, is_hotbar: bool = false):
	if is_hotbar == true:
		var slot = get_tree().root.get_node("/root/" + str(Global.player.data["level"]) + "/CanvasLayer/UI/HotBar/HotBarSlots/HotBarSlot" + str(slot_index + 1))
		if slot != null and slot.item != null:
			slot.item.set_item(item_name, new_quantity)
	if is_hotbar == false:
		var slot = get_tree().root.get_node("/root/" + str(Global.player.data["level"]) + "/CanvasLayer/UI/Inventory/GridContainer/Slot" + str(slot_index + 1))
		if slot != null and slot.item != null:
			slot.item.set_item(item_name, new_quantity)

func remove_item(slot : SlotClass, is_hotbar : bool = false):
	if slot != null:
		if is_hotbar:
			hotbar.erase(slot.slot_index)
		else:
			inventory.erase(slot.slot_index)
	
func add_item_to_empty_slot(item : ItemClass, slot : SlotClass, is_hotbar : bool = false):
	if is_hotbar:
		hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
	else:
		inventory[slot.slot_index] = [item.item_name, item.item_quantity]
	
	
func add_item_quantity(slot : SlotClass, quantity_to_add : int, is_hotbar : bool = false):
	if is_hotbar:
		hotbar[slot.slot_index][1] += quantity_to_add
	else:
		inventory[slot.slot_index][1] += quantity_to_add
	
func remove_item_quest(type : String, amount : int):
	for item in hotbar:
		if hotbar[item][0] == type and hotbar[item][1] >= amount:
			hotbar[item][1] -= amount
			if hotbar[item][1] == 0:
				hotbar.erase(type)
			update_slot_visual(item, hotbar[item][0], hotbar[item][1], true)
			return true
			
	for item in inventory:
		if inventory[item][0] == type and inventory[item][1] >= amount:
			inventory[item][1] -= amount
			if inventory[item][1] == 0:
				inventory.erase(type)
			update_slot_visual(item, inventory[item][0], inventory[item][1])
			return true

func active_item_scroll_up():
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
	Global.player.switch_weapon()
	emit_signal("active_item_updated")
	
func active_item_scroll_down():
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	else:
		active_item_slot -= 1
	Global.player.switch_weapon()
	emit_signal("active_item_updated")
	
func quest_succ() -> bool:
	return true
