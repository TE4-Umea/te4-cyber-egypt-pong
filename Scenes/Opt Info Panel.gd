extends Label
var info_panel

# Called when the node enters the scene tree for the first time.
func _ready():
	info_panel = get_parent().get_node("Opt Info Panel")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_opt_1_pressed():
	info_panel.text = "Grot"


func _on_opt_2_pressed():
	info_panel.text = "Makari"
