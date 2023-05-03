extends Control
## Provides pause and game over scene functionality
##
## By default, "pause" scene is what is displayed when the user presses the "escape" key. 
## Calling in the state variable from the Main script allows for conditional behavior dependant on what state the game is in.
## The two states that are being passed into this script "DESTROYED" and "SUCCESS" change the visibility of the "Restart" button.
## Dependant on what state the game is in, the text label "Status" will change to reflect the state of the game.

const EncyclopaediaScene = preload("res://Encyclopaedia.tscn")

## Inside the ready function signals from the buttons are connected to other functions in the script.
## These signals are connected upon Menu entering the scene tree.
func _ready():
	pause()
	$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Resume.pressed.connect(unpause)
	$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer2/Encyclopedia.pressed.connect(make_encyclopaedia_visible)
	$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer3/Exit.pressed.connect(get_tree().quit)
	$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Restart.pressed.connect(restart)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


## The restart function unpauses the scene tree, and reloads the Main scene. 
## This function is called on the restart button, which is made visible when a game over state is recieved from the Main game script.
func restart():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Main.tscn")
	
	
## The make_encyclopaedia_visible function instantiates an encyclopaedia scene from the previously declared PackedScene, EncyclopaediaScene
##
func make_encyclopaedia_visible():
		var encyclopaedia = EncyclopaediaScene.instantiate()
		add_child(encyclopaedia)
		
		
## The unpause function unpauses the scene tree and sets the visiblity of the attached scene to false.
func unpause():
	get_tree().paused = false
	visible = false



## The pause function pauses the scene tree and sets the visibility of the attached scene to true
## Visibility being set to true allows for processing to occur on the attached scene.
func pause():
	get_tree().paused = true
	visible = true

## The change_title function sets parameters of child nodes to state specifc information, such as "Successful Landing!"
## This function gets called into the main game script.
func change_title(state, game_over_reason):
	match state:
		
		5:
			$PanelContainer/MarginContainer/VBoxContainer/MarginContainer/Status.text = "Sucessful Landing!" 
			$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Restart.visible = true
			$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Resume.visible = false
			#uses the corresponding states from the Main script.
			#SUCCESS = 5
			#if the State enum in Main is changed at all this behavior will apply to the corresponding value in the enum variable.
			
			
		6:
			$PanelContainer/MarginContainer/VBoxContainer/MarginContainer/Status.text = "Lander Destroyed!" 
			$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Restart.visible = true
			$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Resume.visible = false
			match game_over_reason:
				
				0:
					$PanelContainer/MarginContainer/VBoxContainer/MarginContainer2/Reason.text = "Heatshield became compromised whilst vessel was under heating or\nlander destroyed by atmospheric heating due to early jettison of heatshield.\n Maybe try using a thicker heatshield?"
				1:
					$PanelContainer/MarginContainer/VBoxContainer/MarginContainer2/Reason.text = "Atmospheric heating applied to side of backshell damaged lander inside, communication lost with lander.\n Keep the lander level to ensure the heatshield can do its job."
					
				2:
					$PanelContainer/MarginContainer/VBoxContainer/MarginContainer2/Reason.text = "Catastrophic impact with surface. \n Using a bigger parachute may result in more fuel being available for the powered descent."
			#DESTROYED = 6
