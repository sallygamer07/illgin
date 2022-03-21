extends Node2D

const SlotClass = preload("res://player/Slot.gd")

onready var inventory_slot = $GridContainer


func _ready():
	var slots = inventory_slot.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].slot_type = SlotClass.SlotType.INVENTORY
	initialize_inventory()
	
func _process(_delta):
	if Global.player != null:
		$HBoxContainer/coinLabel.text = str(Global.player.coin)
		
func initialize_inventory():
	var slots = inventory_slot.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
			if PlayerInventory.inventory[i][1] <= 0:
				PlayerInventory.remove_item(slots[i])
				slots[i].erase_used_item(slots[i].item)
		
func slot_gui_input(event : InputEvent, slot : SlotClass):
	if event is InputEventMouseButton:
		if event.is_action_pressed("item_click"):
			if find_parent("UI").holding_item != null:
				if !slot.item:
					left_click_empty_slot(slot)
				else:
					if find_parent("UI").holding_item.item_name != null:
						if find_parent("UI").holding_item.item_name != slot.item.item_name:
							left_click_different_item(event, slot)
						else:
							left_click_same_item(slot)
					
			elif slot.item:
				left_click_not_holding(slot)
				
		elif event.button_index == BUTTON_RIGHT && event.pressed:
			if find_parent("UI").holding_item == null:
				if slot.item != null:
					find_parent("UI").selecting_item = slot.item
					right_click_use_slot(slot)
				
								
func _input(_event):
	if find_parent("UI").holding_item:
		find_parent("UI").holding_item.global_position = get_global_mouse_position()
		
func left_click_empty_slot(slot : SlotClass):
	PlayerInventory.add_item_to_empty_slot(find_parent("UI").holding_item, slot)
	slot.putInSlot(find_parent("UI").holding_item)
	find_parent("UI").holding_item = null
	
func left_click_different_item(event : InputEvent, slot : SlotClass):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(find_parent("UI").holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putInSlot(find_parent("UI").holding_item)
	find_parent("UI").holding_item = temp_item
		
func left_click_same_item(slot : SlotClass):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= find_parent("UI").holding_item.item_quantity:
		PlayerInventory.add_item_quantity(slot, find_parent("UI").holding_item.item_quantity)
		slot.item.add_item_quantity(find_parent("UI").holding_item.item_quantity)
		find_parent("UI").holding_item.queue_free()
		find_parent("UI").holding_item = null
	else:
		PlayerInventory.add_item_quantity(slot, able_to_add)
		slot.item.add_item_quantity(able_to_add)
		find_parent("UI").holding_item.decrease_item_quantity(able_to_add)
		
func left_click_not_holding(slot : SlotClass):
	PlayerInventory.remove_item(slot)
	find_parent("UI").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UI").holding_item.global_position = get_global_mouse_position()

	
func right_click_use_slot(slot : SlotClass):
	slot.use_item(find_parent("UI").selecting_item, slot)
