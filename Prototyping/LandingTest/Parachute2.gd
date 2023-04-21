extends RigidBody2D

var air_resistance = Vector2(0,0)
const CD = 1.75
@export var area = 400
var current_density = 0
var surface_density = 0.02
const EULER = 2.71828
var object_altitude = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("PC ", get_parent().get_parent().density)

	_integrate_forces(self)




func drag(state):
	var x =  int(state.get_linear_velocity().x)
	var y = int(state.get_linear_velocity().y)
	x^2
	y^2
	var squared_velocity = Vector2(x,y)
	air_resistance = (CD * get_parent().get_parent().density * squared_velocity * area) / 2
	state.apply_central_impulse(Vector2(-air_resistance))
	


func _integrate_forces(state):
	drag(state)
