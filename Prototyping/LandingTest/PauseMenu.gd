extends Control
## Provides pause and game over scene functionality
##
## By default, "pause" scene is what is displayed when the user presses the "escape" key. 
## Calling in the state variable from the Main script allows for conditional behavior dependant on what state the game is in.
## The two states that are being passed into this script "DESTROYED" and "SUCCESS" change the visibility of the "Restart" button.
## Dependant on what state the game is in, the text label "Status" will change to reflect the state of the game.



## Inside the ready function signals from the buttons are connected to other functions in the script.
## These signals are connected upon Menu entering the scene tree.
func _ready():
	pause()
	$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Resume.pressed.connect(unpause)
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
func change_title(state):
	match state:
		
		5:
			$PanelContainer/MarginContainer/VBoxContainer/Status.text = "Sucessful Landing!" 
			$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Restart.visible = true
			$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Resume.visible = false
			#uses the corresponding states from the Main script.
			#SUCCESS = 6
			#if the State enum in Main is changed at all this behavior will apply to the corresponding value in the enum variable.
			
			
		6:
			$PanelContainer/MarginContainer/VBoxContainer/Status.text = "Lander Destroyed!" 
			$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Restart.visible = true
			$PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/Resume.visible = false
			#DESTROYED = 7
