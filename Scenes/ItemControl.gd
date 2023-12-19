extends Control
var rng = RandomNumberGenerator.new()
var obsec = false
var choice
var info
var op1
var op2
var item
var itemName

signal goSignal

var itemArray = {
	1: "Hot Chili",
	2: "Snail",
	3: "The Long Boi",
	4: "Bob",
	5: "Hard Hitter",
	6: "Recharge"
	}

func _ready():
	itemName = get_parent().get_node("Control/ItemName")
	info = get_node("Opt Info Panel")
	op1 = get_node("Opt 1")
	op2 = get_node("Opt 2")
	visible = true
	_generateItemOptions()

func _generateItemOptions():
	print(itemArray.size())
	var choice = rng.randi_range(1, itemArray.size())
	#opt1.text = itemArray[choice]

func _reset():
	obsec = false
	info.text = ""

func _on_opt_1_pressed():
	obsec = true
	info.text = "Makari"

func _on_opt_2_pressed():
	obsec = true
	info.text = "Grot"

func _on_select_button_pressed():
	if obsec == true :
		visible = !visible
		goSignal.emit()
		_reset()
	else :
		print("We broke")


func _on_player_item_signal():
	if obsec == false :
		visible = !visible
