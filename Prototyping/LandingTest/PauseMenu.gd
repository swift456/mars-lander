extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Background/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Resume.pressed.connect(unpause)
	$Background/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer3/Exit.pressed.connect(get_tree().quit)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func unpause():
	get_tree().paused = false
	visible = false


func pause():
	get_tree().paused = true
	visible = true
