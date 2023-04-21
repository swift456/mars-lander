extends RigidBody2D
var air_resistance = Vector2(0,0)
const CD = 1.9
@export var area = 25.56
var current_density = 0.00436
var surface_density = 0.02
const EULER = 2.71828
var object_altitude = 0
var distance_to_surface = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	object_altitude = snapped((111100 - self.get_global_position().y)/1000, 0.01)

	_integrate_forces(self)


func calc_density():
	while current_density != surface_density:
		current_density = surface_density*(EULER**(-1 * (object_altitude-14) / 11))
		return current_density
	return current_density

func drag(state):
	var x =  int(state.get_linear_velocity().x)
	var y = int(state.get_linear_velocity().y)
	x^2
	y^2
	var squared_velocity = Vector2(x,y)
	air_resistance = (CD * calc_density() * squared_velocity * area) / 2
	state.apply_central_impulse(Vector2(-air_resistance))
	


func _integrate_forces(state):
	drag(state)
