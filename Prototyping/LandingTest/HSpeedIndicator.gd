extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	var h_speed = round(get_parent().get_child(1).get_child(0).get_linear_velocity().x)
	
	self.clear()
	self.add_text(str(h_speed))
	
