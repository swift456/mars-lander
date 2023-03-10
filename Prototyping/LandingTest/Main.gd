extends Node2D

const parachute = preload("res://Parachute2.tscn")
const pause_menu = preload("res://Menu.tscn")

var parachute_area = 2500
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
var parachute_vert_drag = 0
var parachute_hori_drag = 0


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
				_integrate_forces($UI/Node2D/Lander)
				instance = parachute.instantiate()
				
				
				$UI/Node2D/Lander.add_child(instance)
				instance.global_transform.origin = $UI/Node2D/Lander/AttachmentPoint.global_transform.origin
				
				
			
				
				instance.get_node("Attachment").set("node_b", $UI/Node2D/Lander/AttachmentPoint.get_path_to(instance.get_node("RopeSegment3")))
				instance.get_node("Attachment").set("node_a", instance.get_node("RopeSegment3").get_path_to($UI/Node2D/Lander/AttachmentPoint))
				
				
				
				
				
				_state = State.PARACHUTE_DEPLOYED
				
		State.PARACHUTE_DEPLOYED:
				print("Parachute Deployed!")
				parachute_drag()
				
				
		State.PARACHUTE_CUT:
				instance.queue_free()
				parachute_area = 0
				_state = State.PARACHUTE_USED
				
		
		State.LANDED:
			if $UI/Node2D/Lander.get_linear_velocity().y > 800:
				_state = State.DESTROYED
				#Need to instance a new scene here "Success"
		
		State.DESTROYED:
			get_tree().change_scene_to_file("res://StartMenu.tscn")
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
	#function to find out the magnitude of the vector
	vert_drag = density * $UI/Node2D/Lander.get_linear_velocity().y * (area) * CD * 1/2
	hori_drag = density * $UI/Node2D/Lander.get_linear_velocity().x * (area) * CD * 1/2
	$UI/Node2D/Lander.apply_central_impulse(Vector2(-hori_drag,-vert_drag))
	
	
func parachute_drag():
	parachute_vert_drag = density * $UI/Node2D/Lander.get_linear_velocity().y * (parachute_area) * CD * 1/2
	parachute_hori_drag = density * $UI/Node2D/Lander.get_linear_velocity().x * (parachute_area) * CD * 1/2
	instance.apply_central_impulse(Vector2(-parachute_hori_drag,-parachute_vert_drag))
	
func input():
	
	
		
	
	if Input.is_action_just_pressed("parachute") && !_state == State.PARACHUTE_DEPLOYED && !_state == State.PARACHUTE_USED && !_state == State.LANDED:
		_state = State.PARACHUTE_DEPLOY
	if Input.is_action_just_pressed("parachute") && _state == State.PARACHUTE_DEPLOYED:
		_state = State.PARACHUTE_CUT
	
	
	
	
	
	
#
#		



		


func _on_surface_body_entered(body):
	_state = State.LANDED
