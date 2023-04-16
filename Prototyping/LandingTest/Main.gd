extends Node2D
## Handles game logic relating to Lander and different states the game can be in.
##
## The main script of the game. Logic that is not handled in node specific scripts is executed here.
## The main script needs to be able to reliably access information from all of its child nodes.
## The alternative too this in some circumstances means having to reach up to the parent node and then refer down from there to the desired child node
## e.g. the RayCast2D node needs access to information that is stored in the Surface node. 

## A PackedScene of the Parachute2 Scene.
## Allows for easier instanciation, as this scene is not in the scene tree upon launch.
const ParachuteScene = preload("res://Parachute2.tscn")
## A PackedScene of the PauseScene Scene.
## Allows for easier instanciation, as this scene is not in the scene tree upon launch.
const PauseScene = preload("res://Menu.tscn")

## Tracks the air resistance to be applied to the Lander node.
var air_resistance = Vector2(0,0)

## Enum which holds all of the States the game can be in. 
## A state variable is utilised to keep track of the current state of the game.
enum State {
			FREEFALL, ## Default state. The game will start off in the freefall state. The behavior attached to this state tracks the speed of the lander, and relays information back to the user when it is safe to deploy the parachute. 
			PARACHUTE_DEPLOY, ## Generates the parachute instance. If the speed is currently too high for the parachute to be deployed, the game transistions to the PARACHUTE_CUT state.
			PARACHUTE_CUT, ## Removes the connection between the parachute and lander. Sets the node b of the PinJoint2D to "", nullifying the connection between the two rigidbodies.
			PARACHUTE_DEPLOYED,## Relays textual feedback to the user. Acts as an "idle" state whilst the parachute object is connected to the lander.
			PARACHUTE_USED, ## After parachute is either cut, or detached, this state becomes the new FREEFALL. This is to insure that the PARACHUTE_DEPLOY state can only be accessed once.
			SUCCESS, ## Upon colliding with Surface, the landers velocity is evaluated. If the velocity is below a certain value, this state is transistioned to. This state is passed to the PauseMenu script which displays the appropriate information is displayed.
			DESTROYED, ## Upon colliding with Surface, the landers velocity is evaluated. If the velocity is above/equal to a certain value, this state is transistioned to. This state is passed to the PauseMenu script which displays the appropriate information is displayed.
			}
## State variable to track current game state.
var _state = State.FREEFALL

## Atmospheric density on the surface of mars.
const surface_density = 0.02

## This variable initiates the tracked density (dependant on the current altitude of the lander using the different of the collison point of the RayCast2D and RayCast2D's current position).
## Through exponential interpolation when the Lander reaches the surface node, current_density will be equal to surface_density
var current_density = 0.00436

## Eulers number, used for exponential interpolation in the atmospheric density calculation.
const EULER = 2.71828

## Drag Coeffiecent for the Lander node. 
## Value taken from average value of drag coefficient for the bottom face of an aeroshell.
const CD = 1.7


## Tracks the current speed of the lander
## Used to decide whether or not the lander is destroyed upon contact with the surface.
var lander_speed = 0

## Tracks the current altitude of Lander from sea-level (position of surface node)
## In the _process function,  
var lander_altitude = 0

## Tracks whether the surface has been moved.
## This is so that when the player is in freefall, the map is moved into place and they can begin to land.
var surface_moved = false

## Inbuilt function that is called every frame.
## "event" parameter is whatever event that was registered in that frame.
## In the context of this script, this function currently handles the input for escape key.
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pause_menu = PauseScene.instantiate()
		add_child(pause_menu)


## Upon the main scene entering the scene tree, the parachute indicator text is reset, (gets set next frame).
## An impulse is applied to the lander to simulate the velocity upon entering the atmosphere.
func _ready():
	$UI/UILayer/ParachuteIndicator.text = ""
#	$UI/Node2D/Lander.apply_central_impulse(Vector2(0,900))

func calc_heat():
	pass
## The calc_density function works out the current density based on the current altitude of the Lander.
## 
## For other objects such as the parachute and heatshield they would require a hardcoded position of the Surface node, or a node that can be referenced 
## in the their own scripts.
func calc_density():
	while current_density != surface_density:
		current_density = surface_density*(EULER**(-1 * (lander_altitude-50) / 13))
		return current_density
	return current_density
	
## The _process function in this script contains the state machine that tracks the state of the game.
## Dependant on the state the game is currently in, different behavior will be executed.
func _process(delta):
	lander_altitude = snapped($UI/Node2D/Lander.get_global_position().distance_to($Surface.get_global_position())/1000, 0.01)
	print(current_density)
# 	barmetric equation for working out current density, didn't work, returned erroneous values.
#	code kept just for future reference.
#	pressure = .699 * exp(-0.00009 * $UI.getDistance_to_Surface())
#	temperature =  -31 - 0.000998 * $UI.getDistance_to_Surface()
#	current_density =  pressure / (.1921 * temperature + 273.1)
	if !$Surface.on_screen && !surface_moved:
		$Surface.position.x = $UI/Node2D/Lander.position.x 
	else: 
		$Surface.position.x = $UI/Node2D/Lander/Camera2D/SurfaceOrigin.position.x
		surface_moved = true
	
	
	
	
	
	print("State = ", _state)
	match _state:
		
		State.FREEFALL:
			if $UI/Node2D/Lander.get_linear_velocity().y >= 500:
				$UI/UILayer/ParachuteIndicator.text = "Unsafe to deploy parachute!"
				$UI/UILayer/ParachuteIndicator.set("theme_override_colors/font_color", Color(255, 0, 0))
			else: 
				$UI/UILayer/ParachuteIndicator.text = "Safe to deploy!"
				$UI/UILayer/ParachuteIndicator.set("theme_override_colors/font_color", Color(0, 255, 0))
		
		
		State.PARACHUTE_DEPLOY:
				var instance = ParachuteScene.instantiate()
				instance.linear_velocity = $UI/Node2D/Lander/Backshell.get_linear_velocity()
				$UI/Node2D/Lander/Backshell/AttachmentPoint.add_child(instance)
				instance.global_transform.origin = $UI/Node2D/Lander/Backshell/AttachmentPoint.global_transform.origin
				$UI/Node2D/Lander/Backshell/AttachmentPoint.set_node_b(instance.get_node("RopeSegment3").get_path())
				
				
				if instance.get_linear_velocity().y > 500:
					$UI/Node2D/Lander/Backshell/AttachmentPoint.set_node_b("")
					$UI/Node2D/Lander/Backshell/PinToLander1.set_node_b("")
					$UI/Node2D/Lander/Backshell/PinToLander2.set_node_b("")
					$UI/Node2D/Lander/AnimationPlayer.play("leg_deployment")
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
				$UI/Node2D/Lander/Backshell/PinToLander1.set_node_b("")
				$UI/Node2D/Lander/Backshell/PinToLander2.set_node_b("")
				$UI/Node2D/Lander/AnimationPlayer.play("leg_deployment")
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
			
		
		

## Inbuilt function which handles any changes to physic bodies.
## Best to keep calculations in here that are reliant on a fixed frame rate.
## Some calculations, when tied to computer FPS (which will vary depending on hardware)
## can have unintended consequences.
func _physics_process(delta):
	lander_speed = $UI/Node2D/Lander.get_linear_velocity().y
	_integrate_forces($UI/Node2D/Lander)
	input()
	print($UI/UILayer/HBoxContainer/ThrustIndicator.value)
	
	

	
#	var debug_velocity = $UI/Node2D/Lander.get_linear_velocity()
#	print((_state)," ",(debug_velocity)," ",(air_resistance))
	
	


			
			
## Inbuilt function which is best used when changes to a rigidbody would directly contradict the calculations handled by the physics engine.
## In this case, the two functions drag and thrust which apply a force to the object are dealt with inside this function.
func _integrate_forces(state):
#	drag(state)
	thrust($UI/UILayer/HBoxContainer/ThrustIndicator.value)

## The thrust function applies a central_impulse upward on the Lander object. This thrust is applied directly beneath the Lander.
## This is accomplished through the global_transform.y property of the Lander object.
## Thrust accepts a value, float or int. This value is best tied to a meter that is changed via player input.
## In the context of this script thrust takes in a value from the ThrustIndicator node.
## This is a slider which is controlled by the up and down arrows.
## Intensity of the thrust is based on the position of the slider.
## Thrust cannot be applied if the returned value from FuelGauge is not higher than 0.
func thrust(value):
	
	if $UI/UILayer/HBoxContainer/FuelGauge.value > 0:
		var thrust = -$UI/Node2D/Lander.global_transform.y
		thrust = thrust * value
		$UI/Node2D/Lander.apply_central_impulse(thrust)
		$UI/UILayer/HBoxContainer/FuelGauge.value -= value/80
		print($UI/UILayer/HBoxContainer/FuelGauge.value)
	else:
		$UI/UILayer/HBoxContainer/FuelGauge.value = 0
		print("Out of fuel!")

	
## The drag function applies a central impulse to a rigid body using the current density returned by calc_density()
## This function is derived from the equation for drag.
func drag(state):
	#function to find out the magnitude of the vector
	var x =  int(state.get_linear_velocity().x)
	var y = int(state.get_linear_velocity().y)
	x^2
	y^2
	var squared_velocity = Vector2(x,y)
	air_resistance = (CD * calc_density() * squared_velocity * state.area) / 2
	state.apply_central_impulse(Vector2(-air_resistance))
	print(air_resistance)

## The input function handles inputs for the parachute deployment and parachute cut.
## This function can be expanded to hold any inputs that need to be handled during the main game script.
func input():
	if Input.is_action_just_pressed("parachute") && !_state == State.PARACHUTE_DEPLOYED && !_state == State.PARACHUTE_USED:
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

## This signal function tracks when the lander collides with an object.
## This function will only evaluate the lander_speed if the object the lander has collided with is the surface.
## If higher than 20kph the game will move into the DESTROYED state.
## If below 20kph the game will move into the SUCCESS state after 5 seconds have elapsed.
func _on_lander_collided(collider):#
	print(collider)
	if collider == $Surface/Surface:
		if lander_speed > 20:
			_state = State.DESTROYED
		else:
			await get_tree().create_timer(5).timeout
			_state = State.SUCCESS
