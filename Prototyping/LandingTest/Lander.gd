extends RigidBody2D

const parachute = preload("res://Parachute.tscn")
var parachute_deployed = false
var drag = 0.1
var instancing = true
var instance = parachute
enum State {FREEFALL, PARACHUTE_DEPLOY, PARACHUTE_DEPLOYED, THRUST, DESTROYED, PAUSED}
var _state = State.FREEFALL
var parachute_count = 0





func _process(delta):
	
	_integrate_forces(self)
	input()

	print(rotation)
	
#	input()
	
	var debug_velocity = get_linear_velocity()
	print((_state)," ",(debug_velocity),(drag),(parachute_deployed))
	
	match _state:

		State.PARACHUTE_DEPLOY:

			if parachute_count == 0:

				instance = parachute.instance()
				add_child(instance)
				instance.position = Vector2($ParachuteSpawn.position.x,$ParachuteSpawn.position.y + -10)
				var pinjoint = PinJoint2D.new()
				pinjoint.set("node_b", self.get_path())
				pinjoint.set("node_a", instance.get_path())
				add_child(pinjoint)
				pinjoint.global_transform.origin = (instance.global_transform.origin - self.global_transform.origin / 2)
				parachute_count += 1

			if drag <= 2.7:
				print("Parachute Deployed!")
				instance.set_mass(drag)
				drag += 1 * delta
				if drag >= 2.7:
					_state = State.FREEFALL
		State.PARACHUTE_DEPLOYED:
				instance.queue_free()
				_state = State.FREEFALL
		
			
		


			
			

func _integrate_forces(state):
	self.set_applied_torque(0)
	if Input.is_action_pressed("left"):
		self.set_applied_torque(-1000)
	if Input.is_action_pressed("right"):
		self.set_applied_torque(1000)
	if Input.is_action_pressed("thrust"):
		var thrust = -self.global_transform.y
		thrust = thrust/4
		apply_central_impulse(thrust)
	print(rotation)
func input():
	
	
		
	
	if Input.is_action_just_pressed("parachute") && parachute_count == 0:
		_state = State.PARACHUTE_DEPLOY
	if Input.is_action_just_pressed("parachute") && parachute_count >= 1:
		_state = State.PARACHUTE_DEPLOYED
	if Input.is_action_just_pressed("thrust"):
		_state = State.THRUST
	
	
	
	
#
#		
