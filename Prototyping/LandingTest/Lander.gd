extends RigidBody2D

const parachute = preload("res://Parachute.tscn")
var parachute_deployed = false
var parachute_drag = 2
var drag = 1
var instancing = true
var instance = parachute
enum State {FREEFALL, PARACHUTE_DEPLOY, PARACHUTE_CUT, PARACHUTE_DEPLOYED,PARACHUTE_USED, DESTROYED, PAUSED}
var _state = State.FREEFALL






func _process(delta):
	
	
	input()

	print(rotation)
	
#	input()
	
	var debug_velocity = get_linear_velocity()
	print((_state)," ",(debug_velocity),(parachute_drag),(parachute_deployed))
	
	match _state:

		State.PARACHUTE_DEPLOY:
				_integrate_forces(self)
				instance = parachute.instance()
				
				
				add_child(instance)
				instance.global_transform.origin = (self.global_transform.origin)
				
				
				var spring = DampedSpringJoint2D.new()
				spring.set("node_b", self.get_path())
				spring.set("node_a", instance.get_path())
				spring.set_rest_length(-70)
				spring.set_length(-100)
				spring.set_stiffness(6)
				spring.set_damping(1)
				add_child(spring)
				
				
				spring.global_transform.origin = self.global_transform.origin
				
				_state = State.PARACHUTE_DEPLOYED
				
		State.PARACHUTE_DEPLOYED:
				print("Parachute Deployed!")
				set_linear_damp(parachute_drag)
				
		State.PARACHUTE_CUT:
				instance.queue_free()
				
				_state = State.PARACHUTE_USED
				set_linear_damp(drag)
				
		
			
		


			
			

func _integrate_forces(state):
	self.set_applied_torque(0)
	if Input.is_action_pressed("left"):
		self.set_applied_torque(-1000)
	if Input.is_action_pressed("right"):
		self.set_applied_torque(1000)
	if Input.is_action_pressed("thrust"):
		var thrust = -self.global_transform.y
		thrust = thrust
		apply_central_impulse(thrust)
	print(rotation)
func input():
	
	
		
	
	if Input.is_action_just_pressed("parachute") && !_state == State.PARACHUTE_DEPLOYED && !_state == State.PARACHUTE_USED:
		_state = State.PARACHUTE_DEPLOY
	if Input.is_action_just_pressed("parachute") && _state == State.PARACHUTE_DEPLOYED:
		_state = State.PARACHUTE_CUT
	
	
	
	
	
#
#		
