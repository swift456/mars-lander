extends RigidBody2D

var air_resistance = Vector2(0,0)
var density = 0.00002
const CD = 1.7

@export var area = 2500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(delta):
	_integrate_forces(self)



func drag(state):
	#function to find out the magnitude of the vector
	air_resistance = density * state.get_linear_velocity() * (area) * CD * 1/2
	state.apply_central_impulse(Vector2(-air_resistance))


func _integrate_forces(state):
	drag(state)
