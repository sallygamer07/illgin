extends Panel

var default_tex = preload("res://graphics/player/default_slot.png")
var empty_tex = preload("res://graphics/player/empty_slot.png")
var selected_tex = preload("res://graphics/player/item_slot_selected_bg.png")

var default_style : StyleBoxTexture = null
var empty_style : StyleBoxTexture = null
var selected_style : StyleBoxTexture = null

var ItemClass = preload("res://player/Item.tscn")
var item = null
var slot_index
var slot_type

export var ItemSize : bool

enum SlotType {
	HOTBAR = 0,
	INVENTORY,
}

func _ready():
			
	
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	selected_style.texture = selected_tex
	
#	if randi() % 2 == 0:
#		item = ItemClass.instance()
#		add_child(item)
	refresh_style()
	
func _process(_delta):
	if item != null:
		if ItemSize == true:
			item.scale = Vector2(0.25, 0.25)
		else:
			item.scale = Vector2(1, 1)

func refresh_style():
	if SlotType.HOTBAR == slot_type and PlayerInventory.active_item_slot == slot_index:
		set("custom_styles/panel", selected_style)
	elif item == null:
		set("custom_styles/panel", empty_style)
	else:
		set("custom_styles/panel", default_style)
		
func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("UI")
	inventoryNode.add_child(item)
	item = null
	refresh_style()
	
func putInSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("UI")
	inventoryNode.remove_child(item)
	add_child(item)
	refresh_style()
	
func use_item(using_item, slot, is_hotbar : bool = false):
	item = using_item
	var item_name = using_item.item_name
	
	if item != null:
		if is_hotbar == false:
			if PlayerInventory.inventory[slot.slot_index][1] >= 1:
				if item_name == "하급 회복 포션":
					use_item_add_health(item_name, slot)
					
				elif item_name == "하급 마나 포션":
					use_item_add_mana(item_name, slot)
						
				elif item_name == "후라이드 치킨":
					use_item_add_health(item_name, slot)
				
				elif item_name == "고양이 발바닥 부적":
					use_item_add_stat(item_name, slot)
					
			else:
				PlayerInventory.remove_item(slot)
				erase_used_item(item)
				
		if is_hotbar == true:
			if PlayerInventory.hotbar[slot.slot_index][1] >= 1:
				if item_name == "하급 회복 포션":
					use_item_add_health(item_name, slot, is_hotbar)
					
				elif item_name == "하급 마나 포션":
					use_item_add_mana(item_name, slot, is_hotbar)
					
				elif item_name == "후라이드 치킨":
					use_item_add_health(item_name, slot, is_hotbar)
				
				elif item_name == "고양이 발바닥 부적":
					use_item_add_stat(item_name, slot, is_hotbar)
					
			else:
				PlayerInventory.remove_item(slot)
				erase_used_item(item)

func erase_used_item(_item):
	_item.queue_free()
	item = null
	refresh_style()
	
func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
	refresh_style()

func use_item_add_health(item_name, slot, is_hotbar : bool = false):
	if is_hotbar == false:
		var add_health = int(JsonData.item_data[item_name]["AddHealth"])
		if Global.player.health < Global.player.max_health:
			Global.player._health_potion(add_health)
		PlayerInventory.inventory[slot.slot_index][1] -= 1
		slot.item.decrease_item_quantity(1)
		PlayerInventory.update_slot_visual(slot.slot_index, PlayerInventory.inventory[slot.slot_index][0], PlayerInventory.inventory[slot.slot_index][1])
		refresh_style()
		if PlayerInventory.inventory[slot.slot_index][1] == 0:
			PlayerInventory.remove_item(slot)
			erase_used_item(item)
	else:
		var add_health = int(JsonData.item_data[item_name]["AddHealth"])
		if Global.player.health < Global.player.max_health:
			Global.player._health_potion(add_health)
		PlayerInventory.hotbar[slot.slot_index][1] -= 1
		slot.item.decrease_item_quantity(1)
		PlayerInventory.update_slot_visual(slot.slot_index, PlayerInventory.hotbar[slot.slot_index][0], PlayerInventory.hotbar[slot.slot_index][1])
		refresh_style()
		if PlayerInventory.hotbar[slot.slot_index][1] == 0:
			PlayerInventory.remove_item(slot)
			erase_used_item(item)
		
func use_item_add_mana(item_name, slot, is_hotbar : bool = false):
	if is_hotbar == false:
		var add_mana = int(JsonData.item_data[item_name]["AddMana"])
		if Global.player.mana < Global.player.max_mana:
			Global.player.mana += add_mana
		PlayerInventory.inventory[slot.slot_index][1] -= 1
		slot.item.decrease_item_quantity(1)
		PlayerInventory.update_slot_visual(slot.slot_index, PlayerInventory.inventory[slot.slot_index][0], PlayerInventory.inventory[slot.slot_index][1])
		refresh_style()
		if PlayerInventory.inventory[slot.slot_index][1] == 0:
			PlayerInventory.remove_item(slot)
			erase_used_item(item)	
	else:
		var add_mana = int(JsonData.item_data[item_name]["AddMana"])
		if Global.player.mana < Global.player.max_mana:
			Global.player.mana += add_mana
		PlayerInventory.hotbar[slot.slot_index][1] -= 1
		slot.item.decrease_item_quantity(1)
		PlayerInventory.update_slot_visual(slot.slot_index, PlayerInventory.hotbar[slot.slot_index][0], PlayerInventory.hotbar[slot.slot_index][1])
		refresh_style()
		if PlayerInventory.hotbar[slot.slot_index][1] == 0:
			PlayerInventory.remove_item(slot)
			erase_used_item(item)
		
func use_item_add_stat(item_name, slot, is_hotbar : bool = false):
	if is_hotbar == false:
		var add_stat = int(JsonData.item_data[item_name].AddStatPoint)
		if JsonData.item_data[item_name].AddStatName == "wisdom":
			Global.player.wisdom += add_stat
		PlayerInventory.inventory[slot.slot_index][1] -= 1
		slot.item.decrease_item_quantity(1)
		PlayerInventory.update_slot_visual(slot.slot_index, PlayerInventory.inventory[slot.slot_index][0], PlayerInventory.inventory[slot.slot_index][1])
		refresh_style()
		if PlayerInventory.inventory[slot.slot_index][1] == 0:
			PlayerInventory.remove_item(slot)
			erase_used_item(item)
	else:
		var add_stat = int(JsonData.item_data[item_name].AddStatPoint)
		if JsonData.item_data[item_name].AddStatName == "wisdom":
			Global.player.wisdom += add_stat
		PlayerInventory.hotbar[slot.slot_index][1] -= 1
		slot.item.decrease_item_quantity(1)
		PlayerInventory.update_slot_visual(slot.slot_index, PlayerInventory.hotbar[slot.slot_index][0], PlayerInventory.hotbar[slot.slot_index][1])
		refresh_style()
		if PlayerInventory.hotbar[slot.slot_index][1] == 0:
			PlayerInventory.remove_item(slot)
			erase_used_item(item)


