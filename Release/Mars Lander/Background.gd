extends Node2D
var background_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	print("B",position)


func _on_lander_lander_position(position):
	self.position.x = position.x
