extends RigidBody2D

const parachute = preload("res://Parachute.tscn")
var parachute_deployed = false
var drag = 0.1
var instancing = true
var instance = parachute
enum State {FREEFALL, PARACHUTE_DEPLOY, PARACHUTE_DEPLOYED, THRUST, DESTROYED, PAUSED}
var _state = State.FREEFALL
var parachute_count = 0
## Called when the node enters the scene tree for the first time.
#

func _process(delta):
	input()
	var debug_velocity = get_linear_velocity()
	print(_state)
	match _state:
		
		State.PARACHUTE_DEPLOY:
			print((debug_velocity),(drag),(parachute_deployed))
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
					_state = State.PARACHUTE_DEPLOYED
			
func input():
	if Input.is_action_just_pressed("parachute"):
		_state = State.PARACHUTE_DEPLOY
	if Input.is_action_just_pressed("thrust"):
		_state = State.THRUST
	
	
	
#
#		
