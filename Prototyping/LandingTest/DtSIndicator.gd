extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var distance_to_surface = round(get_parent().get_child(1).get_child(0).get_global_position().distance_to(get_parent().get_child(0).get_global_position()))
	
	self.clear()
	self.add_text(str(distance_to_surface))
	

