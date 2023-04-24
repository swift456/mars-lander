extends RigidBody2D
var air_resistance = Vector2(0,0)
@export var area = 5.56
var density = 0
const CD = 1.9
var object_altitude = 0
var current_density = 0.0
const EULER = 2.71828



func _process(delta):
#	print("HS ",object_altitude)
#	print("HS ",density)

	_integrate_forces(self)



	
	

#func calc_density():
#	while current_density <= surface_density:
#		current_density = surface_density*(EULER**(-1 * (object_altitude-0) / 11))
#		return current_density
#	if current_density > surface_density:
#			current_density = 0.2
#	return current_density

func drag(state):
	var x =  int(state.get_linear_velocity().x)
	var y = int(state.get_linear_velocity().y)
	x^2
	y^2
	var squared_velocity = Vector2(x,y)
	air_resistance = (CD * density * squared_velocity * area) / 2
	state.apply_central_impulse(Vector2(-air_resistance))
	


func _integrate_forces(state):
	drag(state)


func _on_ui_distance(collision_point):
	object_altitude = get_global_position().distance_to(collision_point)


func _on_outer_atmo_body_entered(body):
	density = 0.000001 


func _on_upper_atmo_body_entered(body):
	density = 0.00001


func _on_middle_atmo_body_entered(body):
	density = 0.0001


func _on_lower_atmo_body_entered(body):
	density = 0.001


func _on_surface_atmo_body_entered(body):
	density = 0.02
