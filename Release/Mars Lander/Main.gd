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
			FREEFALL, ## Default state. The game will start off in the freefall state. The behavior attached to this 
					## state tracks the speed of the lander, and relays information back to the user when it is safe 
					## to deploy the parachute. 
					
			PARACHUTE_DEPLOY, ## Generates the parachute instance. If the speed is currently too high for the parachute 
							## to be deployed, the game transistions to the PARACHUTE_CUT state.
							
			PARACHUTE_CUT, ## Removes the connection between the parachute and lander.Sets the node b of the 
						## PinJoint2D to "", nullifying the connection between the two rigidbodies.
						
			PARACHUTE_DEPLOYED, ## Relays textual feedback to the user. Acts as an "idle" state whilst the 
								## parachute object is connected to the lander.
							
			PARACHUTE_USED, ## After parachute is either cut, or detached, this state becomes the new FREEFALL.
							## This is to insure that the PARACHUTE_DEPLOY state can only be accessed once.
							
			SUCCESS, ## Upon colliding with Surface, the landers velocity is evaluated. If the velocity is below a
					## certain value, this state is transistioned to. 
					## This state is passed to the PauseMenu script which displays the appropriate information
			DESTROYED, ## Upon colliding with Surface, the landers velocity is evaluated. If the velocity is 
					## above/equal to a certain value, this state is transistioned to. This state is passed to the 
					## PauseMenu script which displays the appropriate information is displayed.
			}
## State variable to track current game state.
var _state = State.FREEFALL

## Atmospheric density on the surface of mars.
const surface_density = 0.02

## This variable initiates the tracked density (dependant on the current altitude of the lander using the different of the collison point of the RayCast2D and RayCast2D's current position).
## Through exponential interpolation when the Lander reaches the surface node, current_density will be equal to surface_density
var current_density = 0

## Eulers number, used for exponential interpolation in the atmospheric density calculation.
const EULER = 2.71828

## Drag Coeffiecent for the Lander node. 
## Value taken from average value of drag coefficient for the bottom face of an aeroshell.
const CD = 1.7

## Measures the strength of shield, this is changed by the users choice at the beginning of the game
## Set to zero to avoid a null instance exception upon runtime
var heatshield_strength

## Tracks the heatshield's health, when depleted the heatshield is seen as being "compromised" or destroyed
var heatshield_health = 50

var game_over_reason = 0

## 
var heatshield_destroyed = false

var destroyed

var node_path = NodePath("")

var parachute_select 

var backshell_visible = 0 

## Tracks the current speed of the lander
## Used to decide whether or not the lander is destroyed upon contact with the surface.
#var lander_speed = 0

## Tracks the current altitude of Lander by taking the result of the raycast node in the UI scene.
## Assignment is handled in process, so it is continually updated.
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
	get_tree().paused = true
	$UI/UILayer/ParachuteIndicator.text = ""
	$UI/Lander.apply_central_impulse(Vector2(0,100))
	
	

func calc_heat():
	pass
## The calc_density function works out the current density based on the current altitude of the Lander.
## 
## For other objects such as the parachute and heatshield they would require a hardcoded position of the Surface node, or a node that can be referenced 
## in the their own scripts.

	
## The _process function in this script contains the state machine that tracks the state of the game.
## Dependant on the state the game is currently in, different behavior will be executed.
func _process(delta):
	
	
		
	
	print("Altitude " ,$UI.distance_to_surface,"Density ",$UI/Lander.density)
	#print($UI/Node2D/Lander.rotation)
# 	barmetric equation for working out current density, didn't work, returned erroneous values.
#	code kept just for future reference.
#	pressure = .699 * exp(-0.00009 * $UI.getDistance_to_Surface())
#	temperature =  -31 - 0.000998 * $UI.getDistance_to_Surface()
#	current_density =  pressure / (.1921 * temperature + 273.1)
	heat($UI/Lander/HeatShield,delta)
	print("Rotation ", $UI/Lander/Backshell.global_rotation_degrees)
	print("Backshell heat", backshell_visible)
	print("HS HE", heatshield_health)
	
	if $Surface.position.distance_to($UI/Lander.position) > 200:
		$Surface.position.x = $UI/Lander.position.x 
	
	if heatshield_destroyed && !_state == State.DESTROYED:
		var node = Node.new()
		$UI/UILayer.add_child(node)
		var label = Label.new()
		label.add_theme_color_override("font_color", Color(1, 0, 0.03137255087495))
		label.add_theme_font_size_override("font_size", 20)
		label.text = "! HEATSHIELD COMPROMISED !"
		label.position = get_viewport_rect().size / 2
		label.position -= (label.size/2)
		node.add_child(label)
		await get_tree().create_timer(2).timeout
		node.queue_free()
		if heat($UI/Lander, delta) > 1 && !destroyed:
			game_over_reason = 0
			_state = State.DESTROYED
			await get_tree().create_timer(0.5).timeout
		

			
			
			
			destroyed = true
	if is_backshell_exposed():
		if heat($UI/Lander/Backshell, delta) > 1:
			backshell_visible += delta
			if backshell_visible >= 5:
				game_over_reason = 1
				_state = State.DESTROYED
	else:
		backshell_visible = 0
	
	
	lander_altitude = $UI.distance_to_surface
	
	print("State = ", _state)
	print("TEMP ",heat($UI/Lander/HeatShield, delta))
	print("Mass ",$UI/Lander/HeatShield.mass)
	match _state:
		
		State.FREEFALL:
				if lander_altitude < 50:
					if $UI/Lander.get_linear_velocity().y >= 350:
						$UI/UILayer/ParachuteIndicator.text = "Unsafe to deploy parachute!"
						$UI/UILayer/ParachuteIndicator.set("theme_override_colors/font_color", Color(255, 0, 0))
					else: 
						$UI/UILayer/ParachuteIndicator.text = "Safe to deploy parachute!"
						$UI/UILayer/ParachuteIndicator.set("theme_override_colors/font_color", Color(0, 255, 0))
				else:
					$UI/UILayer/ParachuteIndicator.text = "Too high to deploy parachute!"
					$UI/UILayer/ParachuteIndicator.set("theme_override_colors/font_color", Color(255, 255, 255))
		
		State.PARACHUTE_DEPLOY:
				if $UI.distance_to_surface > 50:
					_state = State.FREEFALL
				else:
					var instance = ParachuteScene.instantiate()
					match parachute_select:
						0:
							instance.area = 50
							instance.mass = 10
							$UI/Lander/Backshell.mass -= 10
							instance.get_node("ParachuteSprite").modulate = Color(0.98425477743149, 0.71876567602158, 0.32628378272057)
						1:
							instance.area = 100
							instance.mass = 20
							$UI/Lander/Backshell.mass -= 20
							instance.get_node("ParachuteSprite").modulate = Color(1, 0.38864222168922, 0.3136203289032)
							
						2:
							instance.area = 150
							instance.mass = 30
							instance.get_node("ParachuteSprite").modulate = Color(1, 0.41348341107368, 0.27727231383324)
							$UI/Lander/Backshell.mass -= 30
					instance.linear_velocity = $UI/Lander/Backshell.get_linear_velocity()
					$UI/Lander/Backshell/AttachmentPoint.add_child(instance)
					instance.get_child(0).global_transform.origin = $UI/Lander/Backshell/AttachmentPoint.global_transform.origin
					$UI/Lander/Backshell/AttachmentPoint.set_node_b(instance.get_node("Connector").get_path())
					
					
					if instance.get_linear_velocity().y > 350:
						$UI/Lander/Backshell/AttachmentPoint.set_node_b("")
						$UI/Lander/Backshell/PinToLander1.set_node_b("")
						$UI/Lander/Backshell/PinToLander2.set_node_b("")
						$UI/Lander/AnimationPlayer.play("leg_deployment")
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
				$UI/Lander/Backshell/PinToLander1.set_node_b("")
				$UI/Lander/Backshell/PinToLander2.set_node_b("")
				$UI/Lander/AnimationPlayer.play("leg_deployment")
				_state = State.PARACHUTE_USED
				
			
		State.PARACHUTE_USED:
			$UI/UILayer/ParachuteIndicator.text = "Parachute Detached"
			$UI/UILayer/ParachuteIndicator.set("theme_override_colors/font_color", Color(255, 255, 255))
		State.DESTROYED:
			
				
				var pause_menu = PauseScene.instantiate()
				pause_menu.get_node("Control").change_title(State.DESTROYED,game_over_reason)
				add_child(pause_menu)
				_state = State.FREEFALL
			
			
		State.SUCCESS:
			
			var pause_menu = PauseScene.instantiate()
			pause_menu.get_node("Control").change_title(State.SUCCESS,game_over_reason)
			add_child(pause_menu)
			_state = State.FREEFALL
			
		
		

		

## Inbuilt function which handles any changes to physic bodies.
## Best to keep calculations in here that are reliant on a fixed frame rate.
## Some calculations, when tied to computer FPS (which will vary depending on hardware)
## can have unintended consequences.
func _physics_process(delta):
	input()
	
	
	
func is_backshell_exposed():
	if $UI/Lander/Backshell.global_rotation_degrees > 45 || $UI/Lander/Backshell.global_rotation_degrees < -45:
		return true
	else:
		return false

	
#	var debug_velocity = $UI/Node2D/Lander.get_linear_velocity()
#	print((_state)," ",(debug_velocity)," ",(air_resistance))
	
	
func heat(state,delta):
	
	var velocity = state.get_linear_velocity().length_squared() 
	var density = state.density
	var heating_value = 0.5 * density * velocity
	var heat_rate = 0.001 * heating_value
	if heatshield_health > 0:
		heatshield_health -= (heat_rate/100)
		
		state.get_node("HeatOverlay").modulate = Color(0.84313726425171, 0, 0.00784313771874, heat_rate)
		
	elif heatshield_health <= 0 && !heatshield_destroyed:
		$UI/Lander/HeatShield/HeatShieldConnection1.set_node_a("")
		$UI/Lander/HeatShield/HeatShieldConnection2.set_node_a("")
		
		heatshield_destroyed = true
		
	return heat_rate
		
		

## The input function handles inputs for the parachute deployment and parachute cut.
## This function can be expanded to hold any inputs that need to be handled during the main game script.
func input():
	if Input.is_action_just_pressed("parachute") && !_state == State.PARACHUTE_DEPLOYED && !_state == State.PARACHUTE_USED:
		_state = State.PARACHUTE_DEPLOY
	if Input.is_action_just_pressed("parachute") && _state == State.PARACHUTE_DEPLOYED:
		_state = State.PARACHUTE_CUT
	
	
	

	
	
	
#
#		



		




## This signal function tracks when the lander collides with an object.
## This function will only evaluate the lander_speed if the object the lander has collided with is the surface.
## If higher than 20kph the game will move into the DESTROYED state.
## If below 20kph the game will move into the SUCCESS state after 5 seconds have elapsed.
func _on_lander_collided(lander_speed):#
	print("Speed ", lander_speed)
	if lander_speed > 20:
		print("Speed ", lander_speed)
		game_over_reason = 2
		_state = State.DESTROYED
	else:
		print("Speed ", lander_speed)
		await get_tree().create_timer(5).timeout
		_state = State.SUCCESS


func _on_selection_menu_hs_changed(heatshield_choice):
	match heatshield_choice: 
		0:
			$UI/Lander/HeatShield/Sprite2D.modulate = Color(0.98824435472488, 0.30587202310562, 0)
			heatshield_health = 25
			$UI/Lander/HeatShield.mass = 20
		1:
			$UI/Lander/HeatShield/Sprite2D.modulate = Color(0.88709461688995, 0.86753046512604, 0.18083310127258)
			heatshield_health = 50
			$UI/Lander/HeatShield.mass = 30
		2:
			$UI/Lander/HeatShield/Sprite2D.modulate = Color(0.27889686822891, 0.25785693526268, 0.27853071689606)
			heatshield_health = 100
			$UI/Lander/HeatShield.mass = 50





func _on_selection_menu_pc_changed(parachute_choice):
	match parachute_choice: 
		0:
			parachute_select = parachute_choice
			$UI/Lander/Backshell.mass += 10
		1:
			parachute_select = parachute_choice
			$UI/Lander/Backshell.mass += 20
		2:
			parachute_select = parachute_choice
			$UI/Lander/Backshell.mass += 30




func _on_upper_atmo_body_entered(body):
	print("HELLO2")
	$UI.set_time_control(false)
