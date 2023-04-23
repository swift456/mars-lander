extends VBoxContainer

var state_hs = 0


signal state_changed(state_hs)




func _ready():
	pass 
func _process(delta):
	pass


func _on_left_arrow_pressed():
	state_hs -= 1
	emit_signal("state_changed", state_hs)


func _on_right_arrow_pressed():
	state_hs += 1
	emit_signal("state_changed", state_hs)
