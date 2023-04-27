extends VBoxContainer

var state = 0


signal state_changed(state)



func _ready():
	emit_signal("state_changed", state)
	
func _process(delta):
	pass





func _on_time_control_right_pressed():
	state += 1
	if state > 3:
		state = 3
	emit_signal("state_changed", state)

func _on_time_control_left_pressed():
	state -= 1
	if state < 0:
			state = 0
	emit_signal("state_changed", state)
