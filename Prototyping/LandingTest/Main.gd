extends Node2D

const ParachuteScene = preload("res://Parachute2.tscn")
const PauseScene = preload("res://Menu.tscn")

var vert_drag = 0
var hori_drag = 0
var air_resistance = Vector2(0,0)
var instance = ParachuteScene
enum State {FREEFALL, PARACHUTE_DEPLOY, PARACHUTE_CUT, PARACHUTE_DEPLOYED,PARACHUTE_USED,LANDED,SUCCESS, DESTROYED, PAUSED}
var _state = State.FREEFALL
var density = 0.00002
var current_velocity = 0
const CD = 1.7
var parachute_used = false
var lander_speed = 0

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pause_menu = PauseScene.instantiate()
		add_child(pause_menu)

func _ready():
	$UI/Node2D/Lander.apply_central_impulse(Vector2(0,800))

func _process(delta):
	print("State = ", _state)
	match _state:
		State.PARACHUTE_DEPLOY:
				instance = ParachuteScene.instantiate()
				instance.linear_velocity = $UI/Node2D/Lander.get_linear_velocity()
				$UI/Node2D/Lander.add_child(instance)
				instance.global_transform.origin = $UI/Node2D/Lander/AttachmentPoint.global_transform.origin
				$UI/Node2D/Lander/AttachmentPoint.set_node_b(instance.get_node("RopeSegment3").get_path())
				
				_state = State.PARACHUTE_DEPLOYED
				if instance.get_linear_velocity().y >= 300:
					$UI/Node2D/Lander/AttachmentPoint.set_node_b("")
				
		State.PARACHUTE_DEPLOYED:
#				print("Parachute Deployed!")
#				print(instance.air_resistance)
				pass
				
				
		State.PARACHUTE_CUT:
				$UI/Node2D/Lander/AttachmentPoint.set_node_b("")
				_state = State.PARACHUTE_USED
				
			
		State.PARACHUTE_USED:
			pass
				
		State.DESTROYED:
			
			var pause_menu = PauseScene.instantiate()
			pause_menu.get_node("Control").change_title(State.DESTROYED)
			add_child(pause_menu)
			_state = State.FREEFALL
			
			
		State.SUCCESS:
			
			var pause_menu = PauseScene.instantiate()
			pause_menu.get_node("Control").change_title(State.SUCCESS)
			add_child(pause_menu)
			_state = State.FREEFALL
			
		
		


func _physics_process(delta):
	lander_speed = $UI/Node2D/Lander.get_linear_velocity().y
	_integrate_forces($UI/Node2D/Lander)
	input()
	
	
	
	
	
	print($UI/UILayer/HBoxContainer/ThrustIndicator.value)
	
	

	
#	var debug_velocity = $UI/Node2D/Lander.get_linear_velocity()
#	print((_state)," ",(debug_velocity)," ",(air_resistance))
	
	


			
			

func _integrate_forces(state):
	drag(state)
	thrust($UI/UILayer/HBoxContainer/ThrustIndicator.value)
#	rotating($UI/Node2D/Lander)
	

func thrust(value):
	var thrust_value = Vector2(0,value)
	var thrust = -self.global_transform.y
	thrust = thrust * value
	$UI/Node2D/Lander.apply_central_impulse(thrust)
	
	print(thrust_value)
#	rotating($UI/Node2D/Lander)
	
#func rotating(body):
#
#	if Input.is_action_pressed("left"):
#		body.apply_torque(10000)
#
#	if Input.is_action_pressed("right"):
#		body.apply_torque(-10000)
#
#	body.apply_torque(0)
	
	

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



		


#func _on_surface_body_entered(body):
#	if body.get_linear_velocity().y > 40:
#		_state = State.DESTROYED
#	else:
#		await get_tree().create_timer(5).timeout
#		_state = State.SUCCESS


#func _on_lander_body_entered(body):
#	if body == $UI/Surface:
#		if body.get_linear_velocity().y > 40:
#			_state = State.DESTROYED
#		else:
#			await get_tree().create_timer(5).timeout
#			_state = State.SUCCESS


func _on_lander_collided(collider):
	if collider == $Surface:
		if lander_speed > 40:
			_state = State.DESTROYED
		else:
			await get_tree().create_timer(5).timeout
			_state = State.SUCCESS
