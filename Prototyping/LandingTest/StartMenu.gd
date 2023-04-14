extends Control


const EncyclopaediaScene = preload("res://Encyclopaedia.tscn")


func _ready():
	$Background/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/StartGame.pressed.connect(start_game)
	$Background/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer2/Encyclopedia.pressed.connect(make_encyclopaedia_visible)
	$Background/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer3/Exit.pressed.connect(get_tree().quit)

# Called when the node enters the scene tree for the first time. 





	
func make_encyclopaedia_visible():
		var encyclopaedia = EncyclopaediaScene.instantiate()
		add_child(encyclopaedia)

func start_game():
	get_tree().change_scene_to_file("res://Main.tscn")



