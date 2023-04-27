extends Control
signal player_choice
signal hs_changed
signal pc_changed
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
				emit_signal("hs_changed" ,heatshield_choice)
				
			1: 
				$Background/MarginContainer/VBoxContainer/Heatshield/VBoxContainer/HBoxContainer/Type.text = "Medium"
				heatshield_choice = state
				emit_signal("hs_changed" ,heatshield_choice)
			2: 
				$Background/MarginContainer/VBoxContainer/Heatshield/VBoxContainer/HBoxContainer/Type.text =  "Thick"
				heatshield_choice = state
				emit_signal("hs_changed" ,heatshield_choice)
	print(heatshield_choice)

func _on_parachute_state_changed(state):
		match state:
			0: 
				$Background/MarginContainer/VBoxContainer/Parachute/VBoxContainer/HBoxContainer/Type.text = "Small"
				parachute_choice = state
				emit_signal("pc_changed" ,parachute_choice)
				
			1: 
				$Background/MarginContainer/VBoxContainer/Parachute/VBoxContainer/HBoxContainer/Type.text = "Medium"
				parachute_choice = state
				emit_signal("pc_changed" ,parachute_choice)
			2: 
				$Background/MarginContainer/VBoxContainer/Parachute/VBoxContainer/HBoxContainer/Type.text =  "Large"
				parachute_choice = state
				emit_signal("pc_changed" ,parachute_choice)

func _on_continue_button_pressed():
	self.visible = false
	get_tree().paused = false
	
	emit_signal("changed" ,heatshield_choice,parachute_choice)
	



