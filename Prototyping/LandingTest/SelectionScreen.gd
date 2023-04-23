extends Control
signal player_choice
signal changed
var heatshield_choice
var parachute_choice

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_heatshield_state_changed(state):
	match state:
			0: 
				$Background/MarginContainer/VBoxContainer/Heatshield/VBoxContainer/HBoxContainer/Type.text = "Thin"
				heatshield_choice = state
				emit_signal("changed" ,heatshield_choice)
				
			1: 
				$Background/MarginContainer/VBoxContainer/Heatshield/VBoxContainer/HBoxContainer/Type.text = "Medium"
				heatshield_choice = state
				emit_signal("changed" ,heatshield_choice)
			2: 
				$Background/MarginContainer/VBoxContainer/Heatshield/VBoxContainer/HBoxContainer/Type.text =  "Thick"
				heatshield_choice = state
	print(heatshield_choice)


func _on_continue_button_pressed():
	self.visible = false
	get_tree().paused = false
	
	emit_signal("changed" ,heatshield_choice)
	
