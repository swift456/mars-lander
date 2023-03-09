extends Node2D

const parachute = preload("res://Parachute.tscn")
const pause_menu = preload("res://Menu.tscn")

var parachute_area = 0
var vert_drag = 0
var hori_drag = 0
var instancing = true
var instance = parachute
enum State {FREEFALL, PARACHUTE_DEPLOY, PARACHUTE_CUT, PARACHUTE_DEPLOYED,PARACHUTE_USED,LANDED, DESTROYED, PAUSED}
var _state = State.FREEFALL
var density = 0.000002
var area = 300
var current_velocity = 0
const CD = 1.7




func _ready():
	pass




func _physics_process(delta):
	
	_integrate_forces($UI/Node2D/Lander)
	input()

	
	

	
	var debug_velocity = $UI/Node2D/Lander.get_linear_velocity()
	print((_state)," ",(debug_velocity)," ",(hori_drag))
	
	match _state:

		State.PARACHUTE_DEPLOY:
				_integrate_forces($UI/Node2D/Lander)
				instance = parachute.instantiate()
				
				
				$UI/Node2D/Lander.add_child(instance)
				instance.global_transform.origin = ($UI/Node2D/Lander.global_transform.origin)
				
				
				var spring = PinJoint2D.new()
				spring.set("node_b", $UI/Node2D/Lander.get_path())
				spring.set("node_a", instance.get_path())
				$UI/Node2D/Lander.add_child(spring)
				
				
				spring.global_transform.origin = $UI/Node2D/Lander.global_transform.origin
				
				_state = State.PARACHUTE_DEPLOYED
				
		State.PARACHUTE_DEPLOYED:
				print("Parachute Deployed!")
				parachute_area = 2500
				
				
		State.PARACHUTE_CUT:
				instance.queue_free()
				parachute_area = 0
				_state = State.PARACHUTE_USED
				
		
		State.LANDED:
			if $UI/Node2D/Lander.get_linear_velocity().y > 40:
				_state = State.DESTROYED
				#Need to instance a new scene here "Success"
		
		State.DESTROYED:
			get_tree().change_scene_to_file("res://Menu.tscn")
			#Need to instance a new scene here "DESTROYED"
			
		
			
		
		


			
			

func _integrate_forces(state):
	drag()
	$UI/Node2D/Lander.apply_torque(0)
	if Input.is_action_pressed("left"):
		$UI/Node2D/Lander.apply_torque(-100)
	if Input.is_action_pressed("right"):
		$UI/Node2D/Lander.apply_torque(100)
	if Input.is_action_pressed("thrust"):
		var thrust = -$UI/Node2D/Lander.global_transform.y
		thrust = thrust
		$UI/Node2D/Lander.apply_central_impulse(thrust)
	print(rotation)
	
	
func drag():
	
	vert_drag = density * $UI/Node2D/Lander.get_linear_velocity().y * (area+parachute_area) * CD * 1/2
	hori_drag = density * $UI/Node2D/Lander.get_linear_velocity().x * (area+parachute_area) * CD * 1/2
	$UI/Node2D/Lander.apply_central_impulse(Vector2(-hori_drag,-vert_drag))
	
	
func input():
	
	
		
	
	if Input.is_action_just_pressed("parachute") && !_state == State.PARACHUTE_DEPLOYED && !_state == State.PARACHUTE_USED && !_state == State.LANDED:
		_state = State.PARACHUTE_DEPLOY
	if Input.is_action_just_pressed("parachute") && _state == State.PARACHUTE_DEPLOYED:
		_state = State.PARACHUTE_CUT
	
	
	
	
	
	
#
#		



		


func _on_surface_body_entered(body):
	_state = State.LANDED
