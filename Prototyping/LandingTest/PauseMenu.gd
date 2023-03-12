extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pause()
	$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Resume.pressed.connect(unpause)
	$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer3/Exit.pressed.connect(get_tree().quit)
	$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Restart.pressed.connect(restart)
	#Maybe have "invisible nodes" which contain the button "Restart" which replaces "Resume" by making resume invisible and restart visible, that should work.
	#Then that behaviour can be linked to another function "restart" which just changes scene to Main, will that load it in again? hopefully.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func restart():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Main.tscn")
	

func unpause():
	get_tree().paused = false
	visible = false


func pause():
	get_tree().paused = true
	visible = true

func change_title(state):
	match state:
		
		6:
			$PanelContainer/MarginContainer/VBoxContainer/Status.text = "Sucessful Landing!" 
			$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Restart.visible = true
			$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Resume.visible = false
			#behavior to make button visible can be stored here in these state variables 
			#uses the corresponding states from the Main script.
			#SUCCESS = 6
			#if the State enum in Main is changed at all this behavior will apply to the corresponding value in the enum variable.
			
			
		7:
			$PanelContainer/MarginContainer/VBoxContainer/Status.text = "Lander Destroyed!" 
			$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Restart.visible = true
			$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Resume.visible = false
			#DESTROYED = 7
