extends Node2D

const ParachuteScene = preload("res://Parachute2.tscn")
const PauseScene = preload("res://Menu.tscn")

var vert_drag = 0
var hori_drag = 0
var air_resistance = Vector2(0,0)
var instance = ParachuteScene
enum State {FREEFALL, PARACHUTE_DEPLOY, PARACHUTE_CUT, PARACHUTE_DEPLOYED,PARACHUTE_USED,LANDED,SUCCESS, DESTROYED, PAUSED}
var _state = State.FREEFALL
var surface_density = 0.00002
var current_density = 0.0000436
var current_velocity = 0
const EULER = 2.71828
const CD = 1.7
var parachute_used = false
var lander_speed = 0
var lander_fuel = 1000

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pause_menu = PauseScene.instantiate()
		add_child(pause_menu)

func _ready():
	$UI/UILayer/ParachuteIndicator.text = ""
	$UI/Node2D/Lander.apply_central_impulse(Vector2(0,800))

func _process(delta):
	#something about this is causing it to evaluate to zero, when commented out value printed is what it is declared as.
	current_density = surface_density*(EULER**(-1 * ($UI.getDistance_to_Surface()-0) / 13000))
	print(current_density)
	
	
	
	
	
	print("State = ", _state)
	match _state:
		State.FREEFALL:
			if $UI/Node2D/Lander.get_linear_velocity().y >= 300:
				$UI/UILayer/ParachuteIndicator.text = "Unsafe to deploy parachute!"
				$UI/UILayer/ParachuteIndicator.set("theme_override_colors/font_color", Color(255, 0, 0))
			else: 
				$UI/UILayer/ParachuteIndicator.text = "Safe to deploy!"
				$UI/UILayer/ParachuteIndicator.set("theme_override_colors/font_color", Color(0, 255, 0))
		
		
		State.PARACHUTE_DEPLOY:
				instance = ParachuteScene.instantiate()
				instance.linear_velocity = $UI/Node2D/Lander.get_linear_velocity()
				$UI/Node2D/Lander.add_child(instance)
				instance.global_transform.origin = $UI/Node2D/Lander/AttachmentPoint.global_transform.origin
				$UI/Node2D/Lander/AttachmentPoint.set_node_b(instance.get_node("RopeSegment3").get_path())
				
				
				if instance.get_linear_velocity().y > 700:
					$UI/Node2D/Lander/AttachmentPoint.set_node_b("")
					_state = State.PARACHUTE_USED
				else:
					_state = State.PARACHUTE_DEPLOYED	
		State.PARACHUTE_DEPLOYED:
#				print("Parachute Deployed!")
#				print(instance.air_resistance)
				$UI/UILayer/ParachuteIndicator.text = "Parachute Deployed"
				$UI/UILayer/ParachuteIndicator.set("theme_override_colors/font_color", Color(255, 255, 255))
				pass
				
				
		State.PARACHUTE_CUT:
				$UI/Node2D/Lander/AttachmentPoint.set_node_b("")
				_state = State.PARACHUTE_USED
				
			
		State.PARACHUTE_USED:
			$UI/UILayer/ParachuteIndicator.text = "Parachute Detached"
			$UI/UILayer/ParachuteIndicator.set("theme_override_colors/font_color", Color(255, 255, 255))
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
	
	if $UI/UILayer/HBoxContainer/TextureProgressBar.value > 0:
		var thrust_value = Vector2(0,value)
		var thrust = -$UI/Node2D/Lander.global_transform.y
		thrust = thrust * value
		$UI/Node2D/Lander.apply_central_impulse(thrust)
		$UI/UILayer/HBoxContainer/TextureProgressBar.value -= value/80
		print($UI/UILayer/HBoxContainer/TextureProgressBar.value)
	else:
		$UI/UILayer/HBoxContainer/TextureProgressBar.value = 0
		print("Out of fuel!")
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
	air_resistance = current_density * state.get_linear_velocity() * (state.area) * CD * 1/2
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
