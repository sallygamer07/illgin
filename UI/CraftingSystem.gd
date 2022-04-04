extends Panel

onready var craft_button = preload("res://UI/CraftingIconButton.tscn")
onready var Ing_list = preload("res://UI/Ingr_Label.tscn")

var craft_name

var recipes = {
	"제작대" : {"통나무" : 4}
}


func _ready():
	load_crafting_grid()
	
	
func load_crafting_grid():
	for i in recipes:
		var add_craft = craft_button.instance()
		add_craft.icon = load("res://graphics/objects/" + str(i) + ".png")
		add_craft.NAME = str(i)
		$Buttons.add_child(add_craft)
		
func Item_pressed(NAME):
	craft_name = NAME
	$craftName.text = craft_name
	var ingredients = get_node("Ingredients")
	for n in ingredients.get_children():
		ingredients.remove_child(n)
		n.queue_free()
	for i in recipes[craft_name]:
		var add_label = Ing_list.instance()
		add_label.text = str(i) + "  0 /" + str(recipes[craft_name][i])
		for item in PlayerInventory.inventory:
			if PlayerInventory.inventory[item].has(i):
				add_label.text = str(i) + "  " + str(PlayerInventory.inventory[item][1]) + " /" + str(recipes[craft_name][i])

		for item in PlayerInventory.hotbar:
			if PlayerInventory.hotbar[item].has(i):
				add_label.text = str(i) + "  " + str(PlayerInventory.hotbar[item][1]) + " /" + str(recipes[craft_name][i])

		$Ingredients.add_child(add_label)


func _on_CraftBtn_pressed():
	var cancraft = false
	
	for i in recipes[craft_name]:
		for item in PlayerInventory.inventory:
			if PlayerInventory.inventory[item].has(i):
				if recipes[craft_name][i] <= PlayerInventory.inventory[item][1]:
					print("true")
					cancraft = true
				else:
					cancraft = false
					
		for item in PlayerInventory.hotbar:
			if PlayerInventory.hotbar[item].has(i):
				if recipes[craft_name][i] <= PlayerInventory.hotbar[item][1]:
					print("true")
					cancraft = true
				else:
					cancraft = false
			
		if cancraft == true:
			PlayerInventory.remove_item_quest(i, recipes[craft_name][i])
			PlayerInventory.add_item(craft_name, 1)
			get_node("Ingredients/Ingr_Label").text = str(i) + "  0 /" + str(recipes[craft_name][i])
			for item in PlayerInventory.inventory:
				if PlayerInventory.inventory[item].has(i):
					get_node("Ingredients/Ingr_Label").text = str(i) + "  " + str(PlayerInventory.inventory[item][1]) + " /" + str(recipes[craft_name][i])
			
			for item in PlayerInventory.hotbar:
				if PlayerInventory.hotbar[item].has(i):
					get_node("Ingredients/Ingr_Label").text = str(i) + "  " + str(PlayerInventory.hotbar[item][1]) + " /" + str(recipes[craft_name][i])
		
