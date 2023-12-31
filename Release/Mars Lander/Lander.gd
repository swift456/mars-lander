extends RigidBody2D

var node_path = NodePath("")
signal lander_position

var air_resistance = Vector2(0,0)
var surface_density = 0.02
var density = 0
const EULER = 2.71828
const CD = 1.7
@export var area = 54.7
@export var lander_fuel = 1000
var recieved_thrust_value = 0
var object_altitude = 0
var lander_speed 
var lander_average_speed = []
var sound_playing = false


func _ready():
	$DtSLander.add_exception($HeatShield)
	$DtSLander.add_exception($Backshell)
	
	
	

signal collided

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	emit_signal("lander_position", self.position)
	$DtSLander.global_rotation = 0
#	print("L ",object_altitude)
#	print("L ",density)
	thrust(recieved_thrust_value)
	rotating(self)
	_integrate_forces(self)
	
	if !sound_playing:
		$AudioStreamPlayer2D.stream_paused = true
		
	if sound_playing:
		$AudioStreamPlayer2D.stream_paused = false
		
		
		
		
		
func _on_body_entered(body):
	
	if body.is_in_group('surface'):
		emit_signal('collided' , lander_speed)

	

func _physics_process(delta):
	lander_speed = get_linear_velocity().y
	

#func calc_density():
#	while current_density <= surface_density:
#		current_density = surface_density*(EULER**(-1 * (object_altitude-0) / 11))
#		return current_density
#	if current_density > surface_density:
#			current_density = 0.2
#	return current_density


## The drag function applies a central impulse to a rigid body using the current density returned by calc_density()
## This function is derived from the equation for drag.
func drag(state):
	var x =  int(state.get_linear_velocity().x)
	var y = int(state.get_linear_velocity().y)
	x^2
	y^2
	var squared_velocity = Vector2(x,y)
	air_resistance = (CD * density * (squared_velocity/2) * area)
	state.apply_central_impulse(Vector2(-air_resistance))

## Inbuilt function which is best used when changes to a rigidbody would directly contradict the calculations handled by the physics engine.
func _integrate_forces(state):
	drag(state)
	

	

	

## The thrust function applies a central_impulse upward on the Lander object. This thrust is applied directly beneath the Lander.
## This is accomplished through the global_transform.y property of the Lander object.
## Thrust accepts a value, float or int. This value is best tied to a meter that is changed via player input.
## In the context of this script thrust takes in a value from the ThrustIndicator node.
## This is a slider which is controlled by the up and down arrows.
## Intensity of the thrust is based on the position of the slider.
## Thrust cannot be applied if the returned value from FuelGauge is not higher than 0.
func thrust(value):
	if $HeatShield/HeatShieldConnection1.node_a == node_path:
		if lander_fuel > 0:
			var thrust = -transform.y
			thrust = thrust * value
			apply_central_impulse(thrust)
			lander_fuel -= value/80
		
		else:
			lander_fuel = 0
		


	
func rotating(body):
	
	if Input.is_action_pressed("left"):
		body.apply_torque(10000)
		
	if Input.is_action_pressed("right"):
		body.apply_torque(-10000)
		
	body.apply_torque(0)




func _on_v_slider_value_changed(value):
	recieved_thrust_value = value

func _on_outer_atmo_body_entered(body):
	density = 0.000001 
	pass # Replace with function body.

func _on_upper_atmo_body_entered(body):
	density = 0.0001
	sound_playing = true
	

func _on_middle_atmo_body_entered(body):
	density = 0.001
	

func _on_lower_atmo_body_entered(body):
	while density <= 0.009:
		density +=0.0001


func _on_surface_atmo_body_entered(body):
	while density <= 0.02:
		density +=0.001


















































#








#const parachute = preload("res://Parachute.tscn")
#var parachute_area = 0
#var vert_drag = 0
#var hori_drag = 0
#var instancing = true
#var instance = parachute
#enum State {FREEFALL, PARACHUTE_DEPLOY, PARACHUTE_CUT, PARACHUTE_DEPLOYED,PARACHUTE_USED,LANDED, DESTROYED, PAUSED}
#var _state = State.FREEFALL
#var density = 0.000002
#var area = 300
#var current_velocity = 0
#const CD = 1.7
#
#
#
#
#func _ready():
#	pass
#
#
#
#
#func _physics_process(delta):
#
#
#	input()
#
#
#
#
#
#	var debug_velocity = get_linear_velocity()
#	print((_state)," ",(debug_velocity)," ",(hori_drag))
#
#	match _state:
#
#		State.PARACHUTE_DEPLOY:
#				_integrate_forces(self)
#				instance = parachute.instantiate()
#
#
#				add_child(instance)
#				instance.global_transform.origin = (self.global_transform.origin)
#
#
#				var spring = PinJoint2D.new()
#				spring.set("node_b", self.get_path())
#				spring.set("node_a", instance.get_path())
#				add_child(spring)
#
#
#				spring.global_transform.origin = self.global_transform.origin
#
#				_state = State.PARACHUTE_DEPLOYED
#
#		State.PARACHUTE_DEPLOYED:
#				print("Parachute Deployed!")
#				parachute_area = 2500
#
#
#		State.PARACHUTE_CUT:
#				instance.queue_free()
#				parachute_area = 0
#				_state = State.PARACHUTE_USED
#
#
#		State.LANDED:
#			if self.get_linear_velocity().y > 40:
#				_state = State.DESTROYED
#				#Need to instance a new scene here "Success"
#
#		State.DESTROYED:
#			get_tree().change_scene_to_file("res://Menu.tscn")
#			#Need to instance a new scene here "DESTROYED"
#
#
#
#
#
#
#
#
#
#func _integrate_forces(state):
#	drag()
#	self.set_applied_torque(0)
#	if Input.is_action_pressed("left"):
#		self.set_applied_torque(-100)
#	if Input.is_action_pressed("right"):
#		self.set_applied_torque(100)
#	if Input.is_action_pressed("thrust"):
#		var thrust = -self.global_transform.y
#		thrust = thrust
#		apply_central_impulse(thrust)
#	print(rotation)
#
#
#func drag():
#
#	vert_drag = density * self.get_linear_velocity().y * (area+parachute_area) * CD * 1/2
#	hori_drag = density * self.get_linear_velocity().x * (area+parachute_area) * CD * 1/2
#	apply_central_impulse(Vector2(-hori_drag,-vert_drag))
#
#
#func input():
#
#
#
#
#	if Input.is_action_just_pressed("parachute") && !_state == State.PARACHUTE_DEPLOYED && !_state == State.PARACHUTE_USED && !_state == State.LANDED:
#		_state = State.PARACHUTE_DEPLOY
#	if Input.is_action_just_pressed("parachute") && _state == State.PARACHUTE_DEPLOYED:
#		_state = State.PARACHUTE_CUT
#
#
#
#
#
##
##		
#
#
#func _on_Surface_body_entered(body):
#		_state = State.LANDED



















