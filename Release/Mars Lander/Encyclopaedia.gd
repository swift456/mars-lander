extends Control
## Allows for ingame access of information without quitting to the menu
##
## Using a modified script from the Menu.gd script Encyclopaedia will be able to "overlay" ontop of the game scene.
## This allows the user to access the encyclopaedia from the pause scene as its just overlaying another scene ontop of the pause scene
## and turning visibility to false when the user elects to return back to the pause scene. 



## Inside the ready function signals from the buttons are connected to other functions in the script.
## These signals are connected upon Encyclopaedia entering the scene tree.
func _ready():
	entered()
	$ExitButton.pressed.connect(exit)
	




func _process(delta):
	pass


	
	
## The unpause function unpauses the scene tree and sets the visiblity of the attached scene to false.
func exit ():
	visible = false
	get_parent().queue_free()


## The pause function pauses the scene tree and sets the visibility of the attached scene to true
## Visibility being set to true allows for processing to occur on the attached scene.
func entered():
	visible = true
