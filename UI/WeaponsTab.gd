extends Tabs

onready var price1 = str2var($RichTextLabel/control/Panel1/Label.text)
onready var price2 = str2var($RichTextLabel/control/Panel2/Label.text)
onready var price3 = str2var($RichTextLabel/control/Panel3/Label.text)
onready var price4 = str2var($RichTextLabel/control/Panel4/Label.text)
onready var price5 = str2var($RichTextLabel/control/Panel5/Label.text)
onready var panels = $RichTextLabel/control


func _ready():
	pass
#	for item in range(panels.get_child_count() - 2):
#		if global.store.bought[item] == true:
#		panels.get_node("Panel" + str(item + 1)).get_node("Buy").text = "Sold"

func _process(_delta):
	$RichTextLabel/control.position.x = -$HScrollBar.value
	

func buy(price, item_name):
	if Global.player.coin >= price:
		Global.player.coin -= price
		PlayerInventory.add_item(item_name, 1)
#			panels.get_node("Panel" + str(item_num + 1)).get_node("Buy").text = "Sold"
	else:
		var rem = price - Global.player.coin
		$ColorRect/Label.text = str(rem) + "코인이 \n더 필요합니다."
		$ColorRect.show()



func _on_Buy_pressed():
	buy(price1, "평범한 검")

func _on_Buy2_pressed():
	buy(price2, "고깔색 레이피어")

func _on_Buy3_pressed():
	buy(price3, "정육점 창")

func _on_colorrectButton_pressed():
	$ColorRect.hide()


func _on_Buy4_pressed():
	buy(price4, "녹슨 삼지창")


func _on_Buy5_pressed():
	buy(price5, "나무꾼이 떨어뜨린 도끼")
