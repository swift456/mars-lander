extends Node2D
#
#var air_resistance = Vector2(0,0)
#var density = 0.00002
#const CD = 1.7
#@export var area = 20670
#
#func _ready():
#	pass
##	run_drag(true)
#
#
#func _physics_process(delta):
#	_integrate_forces($Lander)
#	if Input.is_action_pressed("left"):
#		$Lander.apply_torque(-100)
#	if Input.is_action_pressed("right"):
#		$Lander.apply_torque(100)
#	$Lander.apply_torque(0)
#
#
#
#func drag(state):
#	#function to find out the magnitude of the vector
#	air_resistance = density * state.get_linear_velocity() * (area) * CD * 1/2
#	state.apply_central_force(Vector2(-air_resistance))
#
#
#func _integrate_forces(state):
#	drag(state)
