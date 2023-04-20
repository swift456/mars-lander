extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var v_speed = round($Node2D/Lander.get_linear_velocity().y)
	
	self.clear()
	self.add_text(str(v_speed))
	

