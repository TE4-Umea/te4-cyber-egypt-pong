extends Control
var rng = RandomNumberGenerator.new()
var obsec = false
var info
var opt1
var opt2
var item1
var item2
var itemName
var selectedItem
var needItem = true

signal goSignal

var itemArray = {
	"1": {"name" : "Hot Chili\n", "desc" : "\nYou can feel the energy coursing through your veins like electricity"},
	"2": {"name" : "Large Boots\n", "desc" : "\nBoots that might be a little big"},
	"3": {"name" : "Penitz Pill\n", "desc" : "\nYou are not you without Penitz"},
	"4": {"name" : "Steroids\n", "desc" : "\nStronger but at what cost"},
	"5": {"name" : "Baseball Bat\n", "desc" : "\nHit those balls like a pro"},
	"6": {"name" : "Energy Drink\n", "desc" : "\nEnergy only for the biggest fighters"}
	}

func _ready():
	itemName = get_parent().get_node("Control/ItemName")
	info = get_node("Opt Info Panel")
	opt1 = get_node("Opt 1")
	opt2 = get_node("Opt 2")
	visible = true
	print(visible)
	_generateItemOptions()

func _generateItemOptions():
	needItem = true
	item1 = rng.randi_range(1, itemArray.size())
	item2 = rng.randi_range(1, itemArray.size())
	opt1.text = itemArray[str(item1)]["name"]
	while needItem == true :
		if item1 != item2 :
			opt2.text = itemArray[str(item2)]["name"]
			needItem = false
		else :
			item2 = rng.randi_range(1, itemArray.size())
		
func _reset():
	obsec = false
	info.text = ""
	item1 = ""
	item2 = ""

func _on_opt_1_pressed():
	obsec = true
	info.text = itemArray[str(item1)]["desc"]
	selectedItem = itemArray[str(item1)]["name"]
func _on_opt_2_pressed():
	obsec = true
	info.text = itemArray[str(item2)]["desc"]
	selectedItem = itemArray[str(item2)]["name"]

func _on_select_button_pressed():
	if obsec == true :
		visible = !visible
		goSignal.emit()
		itemName.text += selectedItem
		_reset()
	else :
		print("We broke")


func _on_player_item_signal():
	print("steg 1")
	if obsec == false :
		_ready()
		print("no item")
		

