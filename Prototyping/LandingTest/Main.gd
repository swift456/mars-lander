extends Node2D

const parachute = preload("res://Parachute2.tscn")
const pause_menu = preload("res://Menu.tscn")

var vert_drag = 0
var hori_drag = 0
var air_resistance = Vector2(0,0)
var instance = parachute
enum State {FREEFALL, PARACHUTE_DEPLOY, PARACHUTE_CUT, PARACHUTE_DEPLOYED,PARACHUTE_USED,LANDED, DESTROYED, PAUSED}
var _state = State.FREEFALL
var density = 0.00002
var current_velocity = 0
const CD = 1.7
var parachute_used = false


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		$PauseMenu.pause()
	

func _ready():
	pass




func _physics_process(delta):
	
	_integrate_forces($UI/Node2D/Lander)
	input()

	
	

	
	var debug_velocity = $UI/Node2D/Lander.get_linear_velocity()
	print((_state)," ",(debug_velocity)," ",(hori_drag))
	
	match _state:
		State.PARACHUTE_DEPLOY:
				instance = parachute.instantiate()
				$UI/Node2D/Lander.add_child(instance)
				instance.global_transform.origin = $UI/Node2D/Lander/AttachmentPoint.global_transform.origin
				$UI/Node2D/Lander/AttachmentPoint.set_node_b(instance.get_node("RopeSegment3").get_path())
				_state = State.PARACHUTE_DEPLOYED
				
				
		State.PARACHUTE_DEPLOYED:
				print("Parachute Deployed!")
				
				
				
		State.PARACHUTE_CUT:
				$UI/Node2D/Lander/AttachmentPoint.set_node_b("")
				_state = State.PARACHUTE_USED
			
			
		State.LANDED:
			if $UI/Node2D/Lander.get_linear_velocity().y > 800:
				_state = State.DESTROYED
				#Need to instance a new scene here "Success"
				
		State.DESTROYED:
			get_tree().change_scene_to_file("res://StartMenu.tscn")
			#Need to instance a new scene here "DESTROYED"
			
		
			
		
		


			
			

func _integrate_forces(state):
	drag(state)
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
	
	
func drag(state):
	#function to find out the magnitude of the vector
	air_resistance = density * state.get_linear_velocity() * (state.area) * CD * 1/2
	state.apply_central_impulse(Vector2(-air_resistance))
	
	
#func parachute_drag():
#	parachute_vert_drag = density * $UI/Node2D/Lander.get_linear_velocity().y * (parachute_area) * CD * 1/2
#	parachute_hori_drag = density * $UI/Node2D/Lander.get_linear_velocity().x * (parachute_area) * CD * 1/2
#	instance.apply_central_impulse(Vector2(-parachute_hori_drag,-parachute_vert_drag))
	
func input():
	
	
		
	
	if Input.is_action_just_pressed("parachute") && !_state == State.PARACHUTE_DEPLOYED && !_state == State.PARACHUTE_USED && !_state == State.LANDED:
		_state = State.PARACHUTE_DEPLOY
	if Input.is_action_just_pressed("parachute") && _state == State.PARACHUTE_DEPLOYED:
		_state = State.PARACHUTE_CUT
	
	
	
	
	
	
#
#		



		


func _on_surface_body_entered(body):
	_state = State.LANDED
